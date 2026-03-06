package testimpl

import (
	"context"
	"os"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/cloud"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	armMonitor "github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/monitor/armmonitor"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

func TestComposableScheduledQueryAlert(t *testing.T, ctx types.TestContext) {

	subscriptionId := os.Getenv("ARM_SUBSCRIPTION_ID")
	if len(subscriptionId) == 0 {
		t.Fatal("ARM_SUBSCRIPTION_ID environment variable is not set")
	}

	credential, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		t.Fatalf("Unable to get credentials: %e\n", err)
	}

	options := arm.ClientOptions{
		ClientOptions: azcore.ClientOptions{
			Cloud: cloud.AzurePublic,
		},
	}

	scheduledQueryClient, err := armMonitor.NewScheduledQueryRulesClient(subscriptionId, credential, &options)
	if err != nil {
		t.Fatalf("Error creating Scheduled Query Rules client: %v", err)
	}

	t.Run("doesScheduledQueryAlertExist", func(t *testing.T) {

		resourceGroupName := terraform.Output(
			t,
			ctx.TerratestTerraformOptions(),
			"resource_group_name",
		)

		scheduledQueryAlertName := terraform.Output(
			t,
			ctx.TerratestTerraformOptions(),
			"scheduled_query_alert_name",
		)

		logAnalyticsWorkspaceID := terraform.Output(
			t,
			ctx.TerratestTerraformOptions(),
			"log_analytics_workspace_id",
		)

		scheduledQueryAlert, err := scheduledQueryClient.Get(
			context.Background(),
			resourceGroupName,
			scheduledQueryAlertName,
			nil,
		)

		if err != nil {
			t.Fatalf("Error getting Scheduled Query Alert: %v", err)
		}

		assert.Equal(t, scheduledQueryAlertName, *scheduledQueryAlert.Name)
		assert.NotEmpty(t, logAnalyticsWorkspaceID)
	})
}
