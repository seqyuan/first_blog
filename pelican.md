Title: pelican blog
Date: 2017-03-14
Category: blog
Tags: pelican
Slug: pelican for blog
Author: seqyuan
Summary: python pelican for blog



```
mkdir seqyuan_blog
cd blog
pelican-quickstart
```

`git clone --branch gh-pages git@github.com:seqyuan/blog.git output`
`make html`

```
cd output
git add -A
git commit -m "change log"
git push origin gh-pages
```


Makefile:1: *** missing separator.  Stop.

`perl -pi -e 's/^  */\t/' Makefile`

