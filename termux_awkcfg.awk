function str_contains(vv,value) {
    return index(vv, value)
}
BEGIN{
    FS = "=";
}
{
    v = "";
    strindex = str_contains($1, "PATH")
    if (strindex > 0) {
        for (i = 2; i <= NF; i++) {
            gsub(/^\'+/, "", $i);
            gsub(/\'+$/, "", $i);
            v = v":"$i
        }
        a[$1] = a[$1]""v""
    }
    else {
        if (!a[$1]) {
            for (i = 2; i <= NF; i++) {
                gsub(/^\'+/, "", $i);
                gsub(/\'+$/, "", $i);
                if (i == 2){
                    v = ""$i
                }
                else {
                    v = v"="$i
                }
            }
            a[$1] = v""
        }
    }
}
END{
    for (ix in a) {
        q = a[ix]""
        gsub(/^:+/, "", q);
        print ix"="q}
}