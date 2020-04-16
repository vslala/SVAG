REPOSITORY_PATH=$1
SEPARATION_DEV_BRANCH="separation-dev"
GRADLE_ARTIFACT_BRANCH="gradle_generated_artifacts"
ALL_JARS_TMP_FILE="./all_jars.dat"
TMP_FOLDER="diff_it_tmp"
DIFF_OUTPUT_FOLDER="${TMP_FOLDER}/output"

# setup
echo "Setting directory structure..."
mkdir -p $TMP_FOLDER
mkdir -p $DIFF_OUTPUT_FOLDER
echo "Created Dir: $TMP_FOLDER"
echo "Created Dir: $DIFF_OUTPUT_FOLDER"

# building artifacts
echo "Checking into the repository folder $(basename $REPOSITORY_PATH) branch $SEPARATION_DEV_BRANCH"
cd $REPOSITORY_PATH
git checkout $SEPARATION_DEV_BRANCH
./gradlew clean && ./gradlew build --parallel

echo "All artifacts generated!"
echo "Copying the artifacts name into the tmp file ($ALL_JARS_TMP_FILE)"
find . -name "*.jar" ! -path '*/tmp/expandedArchives/*' > $ALL_JARS_TMP_FILE

# Read jar file path from the tmp file and copy it into a tmp folder
echo "Copying each generated artifact to the temp directory: ($TMP_FOLDER)"
while read jar_path; do
  cp $jar_path "${TMP_FOLDER}/"
done < ${ALL_JARS_TMP_FILE}

# checkout to another branch
echo "Checking out branch: $GRADLE_ARTIFACT_BRANCH"
git checkout $GRADLE_ARTIFACT_BRANCH
./gradlew clean && ./gradlew build --parallel

# Read jar file path from the tmp file and compare it with the older generated artifact
echo "Generating pkgdiff report for each artifact."
while read jar_path; do
  older_artifact_file_name=$(basename $jar_path)
  pkgdiff -tmp-dir $DIFF_OUTPUT_FOLDER "$TMP_FOLDER/$older_artifact_file_name" $jar_path
done < ${ALL_JARS_TMP_FILE}

# clean up
echo "Deleting tmp folders"
rm -rf $jar_path
