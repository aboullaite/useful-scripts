      #!/bin/bash
      ## your svn repos go here
      REPOS="REPO1 REPO2 REPO3 ..."

      for repo in $REPOS;
      do
         ## Get repos from SVN
         git svn clone svn+ssh://<user>@<url>/<go_to_repo>/$repo  --authors-file=authors.txt --no-metadata --prefix "" -s $repo
         cd $repo
         ## post-import cleanup
         for t in $(git for-each-ref --format='%(refname:short)' refs/remotes/tags); do git tag ${t/tags\//} $t && git branch -D -r $t; done
         for b in $(git for-each-ref --format='%(refname:short)' refs/remotes); do git branch $b refs/remotes/$b && git branch -D -r $b; done
         for p in $(git for-each-ref --format='%(refname:short)' | grep @); do git branch -D $p; done
         git branch -d trunk
         ## Create repo in gitlab, add remote URL and push data to it
         curl --header "PRIVATE-TOKEN: <PRIVATE-TOKEN>" -X POST "http://<GITLAB_URL>/api/v3/projects?name=$repo&namespace_id=<namespace_id>"
         ## You can remove this line
         ## My SVN repos were uppercase and gitlab create them in lowercase
         repo1=$(tr '[:upper:]' '[:lower:]' <<< "$repo")
         git remote remove origin
         git remote add origin git@<<GITLAB_URL>>:<GROUP>/$repo1.git
         git push origin --all
         git push origin --tags
         cd ..
      done;
