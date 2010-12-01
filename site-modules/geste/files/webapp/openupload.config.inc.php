<?php
$CONFIG['WWW_SERVER'] = 'http://cjeanneret.int.lsn.camptocamp.com';

$CONFIG['WWW_ROOT'] = '/www';

$CONFIG['INSTALL_ROOT'] = '/var/www/share/htdocs/openupload-0.4.2';

$CONFIG['DATA_PATH'] = '/var/www/share/private/userfiles';

$CONFIG['database']['type'] = 'mysql';
$CONFIG['database']['host'] = 'localhost';
$CONFIG['database']['user'] = 'openupload';
$CONFIG['database']['password'] = 'thaiBahcah2AeTh';
$CONFIG['database']['name'] = 'openupload';
$CONFIG['database']['prefix'] = '';


$CONFIG['translator'] = 'phparray';

$CONFIG['auth'] = 'default';

$CONFIG['defaultlang'] = 'en';

$CONFIG['site']['title'] = 'Open Upload';
$CONFIG['site']['footer'] = '<a href="http://openupload.sf.net">Open Upload</a> - Created by Alessandro Briosi © 2009';
$CONFIG['site']['webmaster'] = 'cedric.jeanneret@camptocamp.com';
$CONFIG['site']['email'] = 'cedric.jeanneret@camptocamp.com';
$CONFIG['site']['template'] = 'default';


$CONFIG['registration']['email_confirm'] = 'yes';


$CONFIG['max_upload_size'] = '100';

$CONFIG['use_short_links'] = 'yes';

$CONFIG['id_max_length'] = '10';

$CONFIG['id_use_alpha'] = 'yes';

$CONFIG['max_download_time'] = '120';

$CONFIG['multiupload'] = '1';

$CONFIG['allow_unprotected_removal'] = 'no';

$CONFIG['progress'] = 'none';

$CONFIG['logging']['enabled'] = 'yes';
$CONFIG['logging']['db_level'] = '4';
$CONFIG['logging']['syslog_level'] = '0';


$CONFIG['register']['nologingroup'] = 'unregistered';
$CONFIG['register']['default_group'] = 'registered';


$CONFIG['plugins']['0'] = 'captcha';
$CONFIG['plugins']['1'] = 'compress';
$CONFIG['plugins']['2'] = 'email';
$CONFIG['plugins']['3'] = 'expire';
$CONFIG['plugins']['4'] = 'filesize';
$CONFIG['plugins']['5'] = 'grouponip';
$CONFIG['plugins']['6'] = 'mimetypes';
$CONFIG['plugins']['7'] = 'password';


$CONFIG['defaultaction'] = 'u';
?>
