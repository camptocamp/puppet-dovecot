/*

== class: dovecot
Include this class to install and configure a dovecot server.

The following variables can be provided. Some are mandatory, some other are exclusive.

BASE:
  *$dovecot_basedir*    dovecot base directory (optional, string)
  *$dovecot_protocols*  dovecot protocols (optional, space separated values)
  *$dovecot_listen*     which IP address should dovecot listen on (optional, IP)

MAILBOX:
  *$dovecot_mail_location*               mailbox location (optional, string)
  *$dovecot_mail_gid*                    gid for process owner (optional, int)
  *$dovecot_mail_uid*                    uid for process owner (optional, int)
  *$dovecot_mail_privileged_group*       which group will have all rights on emails (for dovecot delivery process) (optional, string)

IMAP proto:
  *$dovecot_imap_login_executable*       imap login executable full path (optional, string)
  *$dovecot_imap_mail_executable*        imap mail executable full path (optional, string)
  *$dovecot_imap_plugins*                imap special plugins we want to load (optioan, string)

POP3 proto:
  *$dovecot_pop3_login_executable*       pop3 login executable full path (optional, string)
  *$dovecot_pop3_mail_executable*        pop3 mail executable full path (optional, string)
  *$dovecot_pop3_plugins*                pop3 special plugins we want to load (optioan, string)

LDA proto:
  *$dovecot_lda_postmaster%*             Address to use when sending rejection mails (mandatory, string)
  *$dovecot_lda_hostname*                Hostname to use in various parts of sent mails (optional, string)
  *$dovecot_lda_plugins*                 additional plugins for lda (optional, string)

SIEVE proto:
  *$dovecot_sieve_login_executable*      sieve login executable full path (optional, string)
  *$dovecot_sieve_mail_executable*       sieve mail executable full path (optional, string)
  *$dovecot_sieve_plugins*               sieve special plugins we want to load (optioan, string)

SSL:
  *$dovecot_ssl_enabled*        activate or not SSL (optional, boolean)
  *$dovecot_ssl_listen*         which IP address should dovecot listen on (optional, IP)
  *$dovecot_ssl_cert*           ssl cert file (optional, string)
  *$dovecot_ssl_key*            ssl key file (optional, string)
  *$dovecot_ssl_ca*             ssl ca file (optional, string)
  *$dovecot_ssl_key_password*   ssl key passphrase (optional, string)
  *$dovecot_ssl_cipher_list*    ssl cipher list (optional, string)

AUTH:
  *$dovecot_auth_ldap* [OR]     tells dovecot to use some ldap backend for user auth (boolean)
  *$dovecot_auth_pam*  [OR]     tells dovecot to use pam for user auth (boolean)
  *$dovecot_autoh_database*     tells dovecot to use either mysql or postgresl backend (string)

  IF you decide to use ldap, you can provide those informations:
    *$slapd_domain*                  ldap domain (mandatory, string)
    *$slapd_allow_v2*                do you want to use ldap v2 proto? (optionnal, boolean)
    *$dovecot_ldap_uri*              LDAP access uri (optional, string)
    *$dovecot_ldap_bind_userdn*      bind DN (optional, string)
    *$dovecot_ldap_userdb_prefetch*  do you want to use dovecot prefetch feature? (optional, boolean)
    *$dovecot_ldap_host*             ldap host (optional, string)
    *$dovecot_ldap_base*             base DN of your ldap (optional, string)
    *$dovecot_ldap_user_attrs*       user attributes in ldap (optional, string)
    *$dovecot_ldap_pass_attrs*       password attribute in ldap (optional, string)

  IF you decide to use a database, you cant provide thos informations:
    *$dovecot_sql_host*              database host (mandatory, string)
    *$dovecot_sql_dbname*            database name (mandatory, string)
    *$dovecot_sql_user*              database username (mandatory, string)
    *$dovecot_sql_password*          database password (mandatory, string)
    *$dovecot_sql_user_query*        sql query to fetch user informations (optional, string)
    *$dovecot_sql_password_query*    sql query to fetch password (optional, string)

  IF you decide to use pam, you have nothing else to do.

*/
class dovecot {
  case $operatingsystem {
    Debian : { include dovecot::debian }
    default: { fail "Nothing to do for $operatingsystem" }
  }
}
