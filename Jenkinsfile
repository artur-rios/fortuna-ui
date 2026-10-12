// Deployment pipeline, run by the self-hosted Jenkins in yggdrasil (github.com/artur-rios/yggdrasil).
//
// All the logic lives in that repository's shared library so the four applications deploy the same
// way. What it does with this repository:
//
//   develop pushed                       -> deploy to development (on demand: left stopped if it was)
//   release/x.y.z pushed                 -> deploy to homologation (on demand, the same way)
//   pull request release/x.y.z -> main   -> wait for every GitHub check to pass, deploy to
//                                           production, merge the pull request, tag vx.y.z,
//                                           delete the release branch
//
// All three environments run on one VPS; development and homologation are turned on with
// `scripts/ygg.sh env start <environment>` there. Each gets its own image build, because the API
// address is compiled into the web bundle.
//
// Build and test stay in GitHub Actions; this file only deploys.

@Library('yggdrasil') _

yggdrasilPipeline(stack: 'fortuna-ui')
