class generic-tmpl::mw-tomcat {

  $tomcat_version = '6.0.26'

  include tomcat::v6
  include tomcat::administration
  include java::v6
  include java::dev
 
}
