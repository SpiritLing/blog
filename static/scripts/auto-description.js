const path = require('path');
const semver = require('semver');
function getPackageVersion() {
    const packageJson = path.join(process.cwd(), 'package.json');
    let description;
    try {
        description = require(packageJson).description;
    } catch (unused) {
        throw new Error('Could not load package.json, please make sure it exists');
    }

    return description;
}
console.log(getPackageVersion());