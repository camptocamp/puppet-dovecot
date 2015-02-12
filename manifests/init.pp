# == class: dovecot
# Include this class to install and configure a dovecot server.
#
# The following variables can be provided. Some are mandatory, some other are exclusive.
#
# BASE:
#   *$dovecot_protocols*  dovecot protocols (optional, space separated values)
#   *$dovecot_login_mode* login process mode ('security' or 'performance', optional, defaut: 'security')
#
# IMAP proto:
#   *$dovecot_imap_mail_max_userip_connections* imap max connections from single IP address (optional, int)
#   *$dovecot_imap_login_max_processes_count* imap max number of login processes (optional, int)
#
# POP3 proto:
#
# LDA proto:
#   *$dovecot_lda_postmaster%*             Address to use when sending rejection mails (mandatory, string)
#   *$dovecot_lda_plugins*                 additional plugins for lda (optional, string)
#
# SIEVE proto:
#   *$dovecot_sieve_login_executable*      sieve login executable full path (optional, string)
#   *$dovecot_sieve_mail_executable*       sieve mail executable full path (optional, string)
#   *$dovecot_sieve_plugins*               sieve special plugins we want to load (optioan, string)
#
# SSL:
#   *$dovecot_ssl_enabled*        activate or not SSL (optional, boolean)
#
# AUTH:
#   *$dovecot_auth_ldap* [OR]     tells dovecot to use some ldap backend for user auth (boolean)
#   *$dovecot_autoh_database*     tells dovecot to use either mysql or postgresl backend (string)
#
#   IF you decide to use ldap, you can provide those informations:
#     *$slapd_domain*                  ldap domain (mandatory, string)
#     *$dovecot_ldap_uri*              LDAP access uri (optional, string)
#     *$dovecot_ldap_bind_userdn*      bind DN (optional, string)
#     *$dovecot_ldap_base*             base DN of your ldap (optional, string)
#     *$dovecot_ldap_user_attrs*       user attributes in ldap (optional, string)
#     *$dovecot_ldap_pass_attrs*       password attribute in ldap (optional, string)
#
#   IF you decide to use a database, you cant provide thos informations:
#     *$dovecot_sql_host*              database host (mandatory, string)
#     *$dovecot_sql_dbname*            database name (mandatory, string)
#     *$dovecot_sql_user*              database username (mandatory, string)
#     *$dovecot_sql_password*          database password (mandatory, string)
#     *$dovecot_sql_user_query*        sql query to fetch user informations (optional, string)
#     *$dovecot_sql_password_query*    sql query to fetch password (optional, string)
#
#   IF you decide to use pam, you have nothing else to do.
class dovecot(
  $dovecot_lda_postmaster,
  $dovecot_imap_mail_max_userip_connections,
  $dovecot_imap_login_max_processes_count,
  $dovecot_lda_plugins,
  $dovecot_ssl_enabled,
  $dovecot_auth_ldap,
  $dovecot_ldap_otherSchems,
  $dovecot_auth_mechanisms,
  $dovecot_auth_sasl_postfix,
  $dovecot_ldap_uri,
  $dovecot_protocols,
  $dovecot_ldap_bind_userdn,
  $dovecot_ldap_user_attrs,
  $dovecot_ldap_pass_attrs,
  $dovecot_ldap_base,
  $dovecot_ldap_options,
  $slapd_domain,
  $dovecot_version = undef,
) {
  case $::operatingsystem {
    'Debian' : { include ::dovecot::debian }
    default: { fail "Nothing to do for ${::operatingsystem}" }
  }
}
