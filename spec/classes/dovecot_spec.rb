require 'spec_helper'

describe 'dovecot' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp/concat',
        })
      end

      context 'when not passing parameters' do
        let (:params) { { } }

        it 'should fail' do
          expect { is_expected.to compile }.to raise_error
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

        it { is_expected.to compile.with_all_deps }
      end
    end
  end

end
