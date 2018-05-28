# dg-utils
Miscellaneous disc golf related scripts and tools

## Setup postfix (mac, 10.13.3)

### Postfix configuration

    sudo vim /etc/postfix/main.cf
   at the bottom add:
	   
	# Gmail SMTP relay
    relayhost = [smtp.gmail.com]:587
     
	# Enable SASL authentication in the Postfix SMTP client.
    smtpd_sasl_auth_enable = yes
    smtp_sasl_auth_enable = yes
    smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
    smtp_sasl_security_options =
    smtp_sasl_mechanism_filter = AUTH LOGIN
     
    # Enable Transport Layer Security (TLS), i.e. SSL.
    smtp_use_tls = yes
    smtp_tls_security_level = encrypt
    tls_random_source = dev:/dev/urandom

next run:

    sudo vim /etc/postfix/sasl_passwd
 add:
 

    [smtp.gmail.com]:587 username@gmail.com:password
 next run:
 

    sudo postmap /etc/postfix/sasl_passwd
    sudo postfix reload
 send a test email:
 

    echo "Test body" | mail -s "Test Subject" username@gmail.com


#### If something goes wrong

    log stream --predicate  '(process == "smtpd") || (process == "smtp")' --info


### Setup cron job
Edit it

    crontab -e
 To run a script every 10 minutes and log the output:
 

    touch ~/disc_log.log
    */10 * * * * ruby ~/check_new_discs_cron.rb > ~/disc_log.log 2>&1
    tail -f ~/disc_log.log
    
