ITER=0;
for release in $(ls --reverse /srv/serviceguru-dev/releases);
do
  if $ITER -gt 1;
  then
    rm -rf $release;
    echo $release;
  fi
  ITER=$(expr $ITER + 1);
done

ls --reverse /srv/serviceguru-dev/releases

