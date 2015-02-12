require 'spec_helper'
describe 'dovecot' do
  context 'when not passing parameters' do
    let (:params) { { } }

    it 'should fail' do
      expect { should compile }.to raise_error(/Must pass/)
    end
  end

  context 'when passing parameters' do
    let (:params) { { 
      :dovecot_lda_postmaster                   => 'foo@example.com',
      :dovecot_imap_mail_max_userip_connections => 10,
      :dovecot_imap_login_max_processes_count   => 10,
      :dovecot_lda_plugins                      => [],
      :dovecot_ssl_enabled                      => false,
      :dovecot_auth_ldap                        => false,
      :dovecot_ldap_other_schems                => [],
      :dovecot_auth_mechanisms                  => [],
      :dovecot_auth_sasl_postfix                => 'foo',
      :dovecot_ldap_uri                         => 'bar',
      :dovecot_protocols                        => [],
      :dovecot_ldap_bind_userdn                 => 'foo',
      :dovecot_ldap_user_attrs                  => 'bar',
      :dovecot_ldap_pass_attrs                  => 'baz',
      :dovecot_ldap_base                        => 'base',
      :dovecot_ldap_options                     => [],
      :slapd_domain                             => 'dom',
    } }

    let (:facts) { {
      :operatingsystem => 'Debian',
      :osfamily        => 'Debian',
      :lsbdistcodename => 'wheezy',
      :id              => 'root',
      :is_pe           => false,
      :path            => '/usr/bin',
      :concat_basedir  => '/tmp/concat',
    } }

    it { should compile.with_all_deps }
  end
end
