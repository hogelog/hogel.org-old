#!/usr/bin/perl
use strict;
use warnings;

my @operation = [
"PUSH", "DUP", "SWAP", "DISCARD",
"PLUS", "MINUS", "TIMES", "DIVIDE", "MODULO",
"STORE", "RETRIEVE",
"L_STRING", "CALL_L", "JUMP_L", "IZ_L", "IN_L", "RETURN", "END",
"OUTPUTC", "OUTPUTN", "READC", "READN",
"ERROR",
"COMMENT"
];
sub print_read_fun {
  my ($fname, @codes) = @_;
  my ($areturn, $breturn, $creturn, $eofreturn, $defreturn) =
    map{/fun:(.+)/?"return $1(input)":"RETURN_CODE(input, ch, \"$fname\", $_)"}@codes;
  print <<FUN_END;
Operation $fname(FILE* input) {
  int ch = getc(input);
  switch(ch) {
    case A:
      $areturn;
    case B:
      $breturn;
    case C:
      $creturn;
    case EOF:
      $eofreturn;
  }
  $defreturn;
}
FUN_END
}
while(<>) {
  print_read_fun(/([a-zA-Z0-9_:]+)/g);
}
