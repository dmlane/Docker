BEGIN {
	m=split("Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec",d,"|")
	for(o=1;o<=m;o++){
	      months[d[o]]=sprintf("%02d",o)
		  }
}
{
	if(/^[a-zA-Z0-9]/) {
		printf "%s ",$0
		next_download="2010-01-01"
		series=1
		next
		}
    if($1=="url:") {
        sub(/^.*url: */,"")
        printf "%s ",$0
		next
        }
    if(/Next sync will download from:/) {
		next_download=$8 "-" months[$7] "-" $6
		next
    }
	if(NF==0) {
		print next_download
		series=0
		}
}
END {
    if(series==1) print next_download
}
