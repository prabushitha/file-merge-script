# File Merge Script

A simple and fast `bash` script for GNU systems to merge multiple files in a directory to a single file.
This can come in handy if you need to merge multiple `CSV` files to a single csv file or multiple `TEXT` files to a single text file.

## How to Run
Suppose you have a set of `txt` files in a directory called `~/myfiles`
```
~/
 └─── myfiles
     │   test1.txt
     │   test2.txt
     │   test3.txt
     │   test4.txt
     │   other.txt
     └─── ...
```

To merge all files with name starting `test` to a output file called `result.txt`
#### Command
```shell
/bin/bash file-merge-script.sh -d ~/myfiles -p 'test' -o 'result.txt'
```

#### Options
- `-d` : (required) directory containing files
- `-p` : (optional) input file prefix | default - all files in the given directory
- `-o` : (optional) output file name | default - 'output.txt'
- `-s` : (optional) line to start from matching files | default - 1
- `-f` : (optional) line to start from first matching file | default - 1
- `-r` : (optional) delete prefix files after output file created
- `-l` : (optional) log prefix

### Scenarios
#### Merge CSV Files
- Merge multiple csv files with headers from the 1st file and ignore headers from the rest of the files
```shell
/bin/bash file-merge-script.sh -d ~/myfiles -p 'test' -o 'result.csv' -f 1 -s 2
```
In above command `-f 1` gets all content (from line 1) of first matching csv file and `-s 2` gets all matching file contents from line 2.
