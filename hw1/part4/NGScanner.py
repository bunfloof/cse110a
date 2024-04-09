import re
from functools import reduce
from time import time
import argparse
import pdb
import sys
sys.path.append("../part2/")
from tokens import tokens,Token,Lexeme
from typing import Callable,List,Tuple,Optional

# No line number this time
class ScannerException(Exception):
    pass

class NGScanner:
    def __init__(self, tokens: List[Tuple[Token,str,Callable[[Lexeme],Lexeme]]]) -> None:
        self.tokens = tokens
        self.build_regex()

    def build_regex(self) -> None:
        regex_parts = []
        for token_type, regex, _ in self.tokens:
            regex_parts.append(f"(?P<{token_type.name}>{regex})")
        self.regex = re.compile("|".join(regex_parts))
    
    def input_string(self, input_string:str) -> None:
        self.istring = input_string
        
    def token(self) -> Optional[Lexeme]:
        # Implement me!
        while True:
            if len(self.istring) == 0:
                return None

            match = self.regex.match(self.istring)
            if match:
                for token_type, _, action in self.tokens:
                    value = match.group(token_type.name)
                    if value:
                        self.istring = self.istring[len(value):]
                        lexeme = Lexeme(token_type, value)
                        result = action(lexeme)
                        if result.token != Token.IGNORE:
                            return result
                        break
            else:
                raise ScannerException()
    
if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument('file_name', type=str)
    parser.add_argument('--verbose', '-v', action='store_true')
    args = parser.parse_args()
    
    f = open(args.file_name)    
    f_contents = f.read()
    f.close()

    verbose = args.verbose

    s = NGScanner(tokens)
    s.input_string(f_contents)

    start = time()
    while True:
        t = s.token()
        if t is None:
            break
        if (verbose):
            print(t)
    end = time()
    print("time to parse (seconds): ",str(end-start))    
