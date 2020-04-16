OUTPUT_FOLDER="artifact_report"
FINAL_REPORT="final_report.csv"
EXTRACTED_WAR="${OUTPUT_FOLDER}/extracted_war"
EXTRACTED_JAR="${OUTPUT_FOLDER}/extracted_jar"
LIST_OF_WAR_FILES="war_files_path.dat"
LIST_OF_JAR_FILES="jar_files_path.dat"
LIST_OF_JAVA_FILES="java_files_path.dat"

function setup {
  mkdir -p "${OUTPUT_FOLDER}"
  mkdir -p $EXTRACTED_WAR
  mkdir -p $EXTRACTED_JAR
}

function cleanup {
  echo "Deleting temporary folders..."
  rm -rf $OUTPUT_FOLDER
}

function generatereport {
  # find list of all .java files in the extracted jar contents
  find ./artifact_report/extracted_jar -name "*.java" >> "${OUTPUT_FOLDER}/${LIST_OF_JAVA_FILES}"

  # generate report header
  echo "Generating CSV Report..."
  echo "#, WAR, JAR, File" > $FINAL_REPORT

  # generate csv report
  index=1
  while read java_file_path; do
    java_file_name=$(basename $java_file_path)
    echo $java_file_path | awk -v i=$index -v filename=$java_file_name -F "/" '{printf("%s,%s,%s,%s\n", i, $4, $5, filename) }' >> $FINAL_REPORT
    index=$((index+1))
  done < "${OUTPUT_FOLDER}/${LIST_OF_JAVA_FILES}"
}

function extractwar {
  war_path=$1
  echo "War File Path: $war_path"
  war_file_name=$(basename $war_path | awk -F ".war" '{print $1}')
  extracted_war_contents_dir="${EXTRACTED_WAR}/$war_file_name"
  extracted_jar_contents_dir="${EXTRACTED_JAR}/$war_file_name"
  echo "Extracting WAR file: ${war_file_name}"
  mkdir -p $extracted_war_contents_dir
  mkdir -p $extracted_jar_contents_dir

  # unzipping the war
  unzip -qqo $war_path -d "./$extracted_war_contents_dir"

  # find all jar files inside libs dir
  find ./$extracted_war_contents_dir/WEB-INF/lib -name "*.jar" > "$extracted_war_contents_dir/${LIST_OF_JAR_FILES}"

  while read jar_path; do
    jar_file_name=$(basename $jar_path | awk -F ".jar" '{print $1}')

    echo "Extracting $war_file_name.war > $jar_file_name.jar"
    unzip -qqo $jar_path -d "$extracted_jar_contents_dir/$jar_file_name"
  done < "$extracted_war_contents_dir/${LIST_OF_JAR_FILES}"

}

# start
setup

# find the list of all war files
find */build/libs -name "*.war" ! -path '*/tmp/expandedArchives/*' > "${OUTPUT_FOLDER}/${LIST_OF_WAR_FILES}"

while read war_path; do
  extractwar $war_path &
done < "${OUTPUT_FOLDER}/${LIST_OF_WAR_FILES}"

wait

generatereport

# clean all the temporary folders
# read -p "Do you wish to delete temporary folders? [Y/n]: " input

cleanup
