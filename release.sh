#!/usr/bin/env bash
set -e

while getopts v: flag
do
    case "${flag}" in
        v) version=${OPTARG};;
    esac
done

echo $version

./build.sh -c ./config/prod.json

rm -rf ./package
mkdir -p package

echo "{
  \"name\": \"@maplelabs/repayment-calculator\",
  \"version\": \"${version}\",
  \"description\": \"Repayment Calculator Artifacts and ABIs\",
  \"author\": \"Maple Labs\",
  \"license\": \"AGPLv3\",
  \"repository\": {
    \"type\": \"git\",
    \"url\": \"https://github.com/maple-labs/repayment-calculator.git\"
  },
  \"bugs\": {
    \"url\": \"https://github.com/maple-labs/repayment-calculator/issues\"
  },
  \"homepage\": \"https://github.com/maple-labs/repayment-calculator\"
}" > package/package.json

mkdir -p package/artifacts
mkdir -p package/abis

cat ./out/dapp.sol.json | jq '.contracts | ."contracts/RepaymentCalc.sol" | .RepaymentCalc' > package/artifacts/RepaymentCalc.json
cat ./out/dapp.sol.json | jq '.contracts | ."contracts/RepaymentCalc.sol" | .RepaymentCalc | .abi' > package/abis/RepaymentCalc.json

npm publish ./package --access public

rm -rf ./package
