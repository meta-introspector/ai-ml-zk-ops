BEGIN { FS=","; print "["; # Start JSON array
  first = 1;
}
NR == 1 { next; } # Skip header row
{
  if (!first) { print ","; # Add comma before subsequent objects
  }
  printf "  {\"count\": %s, \"owner\": \"%s\", \"repo\": \"%s\"}", $1, $2, $3;
  first = 0;
}
END { print "\n]"; # End JSON array
}