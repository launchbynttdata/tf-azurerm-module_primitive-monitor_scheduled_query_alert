package testimpl

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

func TestComposableScheduledQueryAlert(t *testing.T, ctx types.TestContext) {

	t.Run("validateScheduledQueryAlert", func(t *testing.T) {

		scheduledQueryAlertID := terraform.Output(
			t,
			ctx.TerratestTerraformOptions(),
			"scheduled_query_alert_id",
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

		assert.NotEmpty(t, scheduledQueryAlertID)
		assert.NotEmpty(t, scheduledQueryAlertName)
		assert.NotEmpty(t, logAnalyticsWorkspaceID)
	})
}
