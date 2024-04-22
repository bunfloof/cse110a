import shutil
import os

def copy_and_rename_file(src_file_path, dst_file_name):
    current_dir = os.path.dirname(os.path.realpath(__file__))
    dst_file_path = os.path.join(current_dir, dst_file_name)
    shutil.copy(src_file_path, dst_file_path)
    print(f"File copied from {src_file_path} to {dst_file_path}")

def main():
    files_to_copy = {
        "../part1/part1Lexer.py": "part2Lexer.py",
        "../part1/part1Parser.py": "part2Parser.py"
    }
    for src, dst in files_to_copy.items():
        copy_and_rename_file(src, dst)

if __name__ == "__main__":
    main()
