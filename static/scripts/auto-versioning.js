const path = require('path');
const semver = require('semver');
function getPackageVersion() {
    const packageJson = path.join(process.cwd(), 'package.json');
    let version;
    try {
        version = require(packageJson).version;
    } catch (unused) {
        throw new Error('Could not load package.json, please make sure it exists');
    }

    if (!semver.valid(version)) {
        throw new Error('Invalid version number found in package.json, please make sure it is valid');
    }
    return [semver.major(version), semver.minor(version), semver.patch(version)].join('.');
}
console.log(getPackageVersion());