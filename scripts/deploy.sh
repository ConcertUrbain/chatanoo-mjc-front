echo "Zipping sources"
mkdir build
zip -r build/application.zip . -x *.git* build\*

echo "Deploy $TRAVIS_TAG version to S3"
aws s3 cp infra/front.cfn.yml s3://chatanoo-deployments-eu-west-1/infra/front/mjc/$TRAVIS_TAG.cfn.yml
aws s3 cp build/application.zip s3://chatanoo-deployments-eu-west-1/front/mjc/$TRAVIS_TAG.zip

echo "Upload latest"
aws s3api put-object \
  --bucket chatanoo-deployments-eu-west-1 \
  --key infra/front/mjc/latest.cfn.yml \
  --website-redirect-location /infra/front/mjc/$TRAVIS_TAG.cfn.yml
aws s3api put-object \
  --bucket chatanoo-deployments-eu-west-1 \
  --key front/mjc/latest.zip \
  --website-redirect-location /front/mjc/$TRAVIS_TAG.zip
