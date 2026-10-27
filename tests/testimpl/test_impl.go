package testimpl

import (
	"context"
	"os"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	armmonitor "github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/monitor/armmonitor"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// Expected values mirror examples/complete/test.tfvars.
const (
	expectedQuery               = "requests | where tolong(resultCode) >= 500 | project timestamp, cloud_RoleName"
	expectedEvaluationFrequency = "PT5M"
	expectedWindowDuration      = "PT5M"
	expectedMuteDuration        = "PT1H"
	expectedDimensionName       = "cloud_RoleName"
	expectedEmailSubject        = "Azure Alert: Server Error Detected"
	expectedCustomPropertyKey   = "alert_source"
	expectedCustomPropertyValue = "monitor_scheduled_query_alert"
	expectedThreshold           = float64(3)
)

func TestComposableScheduledQueryAlert(t *testing.T, ctx types.TestContext) {

	subscriptionId := os.Getenv("ARM_SUBSCRIPTION_ID")

	if subscriptionId == "" {
		t.Fatal("ARM_SUBSCRIPTION_ID environment variable is not set")
	}

	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		t.Fatalf("Unable to get Azure credentials: %v", err)
	}

	t.Run("validateScheduledQueryAlertExists", func(t *testing.T) {

		resourceGroupName := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(),
			"resource_group_name",
		)

		scheduledQueryAlertName := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(),
			"scheduled_query_alert_name",
		)

		applicationInsightsId := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(),
			"application_insights_id",
		)

		actionGroupId := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(),
			"monitor_action_group_id",
		)

		client, err := armmonitor.NewScheduledQueryRulesClient(
			subscriptionId,
			cred,
			nil,
		)

		if err != nil {
			t.Fatalf("Failed to create Scheduled Query Rules client: %v", err)
		}

		alert, err := client.Get(
			context.Background(),
			resourceGroupName,
			scheduledQueryAlertName,
			nil,
		)

		require.NoError(t, err)
		assert.Equal(t, scheduledQueryAlertName, *alert.Name)

		properties := alert.Properties
		require.NotNil(t, properties)

		assert.Equal(t, []string{applicationInsightsId}, derefAll(properties.Scopes))
		assert.Equal(t, armmonitor.AlertSeverityOne, *properties.Severity)
		assert.Equal(t, expectedEvaluationFrequency, *properties.EvaluationFrequency)
		assert.Equal(t, expectedWindowDuration, *properties.WindowSize)
		assert.Equal(t, true, *properties.Enabled)

		// The rule re-notifies on a fixed cadence instead of resolving itself.
		assert.Equal(t, false, *properties.AutoMitigate)
		assert.Equal(t, expectedMuteDuration, *properties.MuteActionsDuration)

		require.NotNil(t, properties.Criteria)
		require.Len(t, properties.Criteria.AllOf, 1)
		condition := properties.Criteria.AllOf[0]

		assert.Equal(t, expectedQuery, *condition.Query)
		assert.Equal(t, armmonitor.ConditionOperatorGreaterThan, *condition.Operator)
		assert.Equal(t, armmonitor.TimeAggregationCount, *condition.TimeAggregation)
		assert.Equal(t, expectedThreshold, *condition.Threshold)
		assert.Nil(t, condition.MetricMeasureColumn)

		require.Len(t, condition.Dimensions, 1)
		assert.Equal(t, expectedDimensionName, *condition.Dimensions[0].Name)
		assert.Equal(t, armmonitor.DimensionOperatorInclude, *condition.Dimensions[0].Operator)
		assert.Equal(t, []string{"*"}, derefAll(condition.Dimensions[0].Values))

		require.NotNil(t, condition.FailingPeriods)
		assert.Equal(t, int64(1), *condition.FailingPeriods.MinFailingPeriodsToAlert)
		assert.Equal(t, int64(1), *condition.FailingPeriods.NumberOfEvaluationPeriods)

		require.NotNil(t, properties.Actions)
		assert.Equal(t, []string{actionGroupId}, derefAll(properties.Actions.ActionGroups))

		// email_subject reaches the API as an action property, not a first class field.
		require.Contains(t, properties.Actions.ActionProperties, "Email.Subject")
		assert.Equal(t, expectedEmailSubject, *properties.Actions.ActionProperties["Email.Subject"])

		require.Contains(t, properties.Actions.CustomProperties, expectedCustomPropertyKey)
		assert.Equal(t, expectedCustomPropertyValue, *properties.Actions.CustomProperties[expectedCustomPropertyKey])
	})
}

func derefAll(in []*string) []string {
	out := make([]string, 0, len(in))
	for _, v := range in {
		out = append(out, *v)
	}
	return out
}
