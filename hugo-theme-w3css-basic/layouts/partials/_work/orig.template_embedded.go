	t.addInternalTemplate("", "disqus.html", `{{ if .Site.DisqusShortname }}<div id="disqus_thread"></div>
<script>
    var disqus_config = function () {
    {{with .GetParam "disqus_identifier" }}this.page.identifier = '{{ . }}';{{end}}
    {{with .GetParam "disqus_title" }}this.page.title = '{{ . }}';{{end}}
    {{with .GetParam "disqus_url" }}this.page.url = '{{ . | html  }}';{{end}}
    };
    (function() {
        if (["localhost", "127.0.0.1"].indexOf(window.location.hostname) != -1) {
            document.getElementById('disqus_thread').innerHTML = 'Disqus comments not available by default when the website is previewed locally.';
            return;
        }
        var d = document, s = d.createElement('script'); s.async = true;
        s.src = '//' + {{ .Site.DisqusShortname }} + '.disqus.com/embed.js';
        s.setAttribute('data-timestamp', +new Date());
        (d.head || d.body).appendChild(s);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<a href="https://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>{{end}}`)
