#! /bin/bash

# Merge files to a single file
# Command structure:
# /bin/bash merge_files.sh -d directory_containing_input_files -p input_file_prefix -o output_file_name -r -l log_prefix
# Flags
# -d : (required) directory containing files
# -p : (optional) input file prefix | default - all files
# -o : (optional) output file name | default - 'output.txt'
# -s : (optional) start line of matching files | default - 1
# -f : (optional) start line of first matching file | default - 1
# -r : (optional) delete prefix files
# -l : (optional) log prefix
# Example:
# /bin/bash merge_files.sh -d scripts/historical_data_loader/sales/_outputs -p test -o abc.csv
#
# Above command merge all files with name starting as 'test'
# in 'scripts/historical_data_loader/sales/_outputs' directory
# and create a new file called 'abc.csv'
#

usage() {
  echo "/bin/bash merge_csv_files.sh -d directory_containing_input_files [-p input_file_prefix] [-o output_file_name] [-r] [-l]"
  echo "Flags"
  echo "-d : (required) directory containing files"
  echo "-p : (optional) input file prefix | default - all files"
  echo "-o : (optional) output file name | default - 'output.txt'"
  echo "-s : (optional) start line of matching files | default - 1"
  echo "-f : (optional) start line of first matching file | default - 1"
  echo "-r : (optional) delete prefix files"
  echo "-l : (optional) log prefix"
  exit 1
}
# FLAGS
output_file_name="output.txt"
delete_files=false
inp_prefix=""
log_prefix=""
file_start_line=1
while getopts "d:p:o:s:f:rl:" flag;
do
    case "${flag}" in
        d) file_dir=${OPTARG};;
        p) inp_prefix=${OPTARG};;
        o) output_file_name=${OPTARG};;
        s) file_start_line=${OPTARG};;
        f) first_file_start_line=${OPTARG};;
        r) delete_files=true;;
        l) log_prefix=${OPTARG};;
        *) usage;;
    esac
done

if [ -z "${first_file_start_line}" ]; then
  first_file_start_line=${file_start_line}
fi

echo "${log_prefix}log_prefix=${log_prefix}"
echo "${log_prefix}file_dir=${file_dir}"
echo "${log_prefix}inp_prefix=${inp_prefix}"
echo "${log_prefix}output_file_name=${output_file_name}"
echo "${log_prefix}delete_files=${delete_files}"

# VALIDATIONS
if [ -z "${file_dir}" ]; then
  echo "${log_prefix}ERROR: Directory containing input files should be passed with flag -d"
  exit 1
fi

if [ ! -d "${file_dir}" ]; then
  echo "${log_prefix}ERROR: No such directory : ${file_dir}"
  exit 1
fi

files=(${file_dir}/${inp_prefix}*)
if [ ! -f "${files[0]}" ]; then
  echo "${log_prefix}ERROR: Files not found!"
  echo "${log_prefix}DEBUG: Files: ${files[*]}"
  exit 1
fi

merge_dir="merged_${output_file_name}"
# CREATING DIRECTORY TO PUT TEMPORARY OUTPUT FILE
echo "${log_prefix}INFO: Creating new merged directory if not exist in ${file_dir}..."
mkdir -p ${file_dir}/${merge_dir}

echo "${log_prefix}Setting output file name as : $output_file_name"

# START FILE MERGING
echo "${log_prefix}INFO: Number of files to merged=${#files[@]}"
echo "${log_prefix}INFO: files=${files[*]}"
echo "${log_prefix}INFO: Copying first file ${files[0]} to the output file"
if [[ "${first_file_start_line}" -gt "1" ]];
then
  sed $(($first_file_start_line - 1))d ${files[0]} > ${file_dir}/${merge_dir}/${output_file_name}
else
  cp ${files[0]} ${file_dir}/${merge_dir}/${output_file_name}
fi
echo "${log_prefix}INFO: Copying data to the output file"
if [[ "${file_start_line}" -gt "1" ]];
then
  sed -s 1d "${files[@]:1}" >> ${file_dir}/${merge_dir}/${output_file_name}
else
  cat "${files[@]:1}" >> ${file_dir}/${merge_dir}/${output_file_name}
fi
echo "${log_prefix}INFO: Output file saved to merged"

if [ "${delete_files}" = true ]; then
  echo "${log_prefix}INFO: Removing files with prefix ${file_dir}/${inp_prefix}"
  rm ${file_dir}/${inp_prefix}*
  echo "${log_prefix}INFO: Removed files with prefix ${file_dir}/${inp_prefix}"
fi

echo "${log_prefix}INFO: Moving File to root directory"
mv ${file_dir}/${merge_dir}/${output_file_name} ${file_dir}/${output_file_name}
rm -R ${file_dir}/${merge_dir}
echo "${log_prefix}INFO: Output file saved to ${file_dir}/${output_file_name}"
