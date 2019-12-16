devblog=`git show-ref refs/heads/dev-blog`;
ghpages=`git show-ref refs/heads/gh-pages`;

if [ -n "$devblog" ]; then
    git branch -D dev-blog;
else
    echo "dev-blog branch not exist"
fi

if [ -n "$ghpages" ]; then
    git branch -D gh-pages; 
else
    echo "gh-pages branch not exist"
fi