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

		assert.NoError(t, err)
		assert.Equal(t, scheduledQueryAlertName, *alert.Name)
	})
}
