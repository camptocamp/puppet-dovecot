node "agridea-alpages-demo.dmz.lsn.camptocamp.com" {
  include tmpl-sig-dev-ms5-2
  apache::module { ["proxy", "proxy_http"]:}
}
