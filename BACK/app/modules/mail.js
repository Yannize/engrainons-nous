const nodemailer = require('nodemailer');
const smtpTransport = require('nodemailer-smtp-transport');
module.exports = {
    sendMail(email,key) {

        const transporter = nodemailer.createTransport(smtpTransport({
            service: 'gmail',
            host: 'smtp.gmail.com',
            auth: {
                user: process.env.CONTACTEMAIL,
                pass: process.env.PASSWORDEMAIL
            }
        }));

        const mailOptions = {
            from: 'contactengrainonsnous@gmail.com',
            to: email,
            subject: 'Confirm your email',
            text: `To confirm your email click on http://localhost:8080/uservalidate/${email}/${key}
                    To confirm your email click on https://boring-ramanujan-037bed.netlify.app/uservalidate/${email}/${key}
                    <img  src="https://boring-ramanujan-037bed.netlify.app/images/8ceea8ae02e55660332dcccd429c5ad1.png" alt="Grapefruit slice atop a pile of other slices">
            `
        };

        transporter.sendMail(mailOptions, function (error, info) {
            if (error) {
                console.log(error);
            } else {
                console.log('Email sent: ' + info.response);
            }
        });
    
    },
    sendReset(body) {

        const transporter = nodemailer.createTransport(smtpTransport({
            service: 'gmail',
            host: 'smtp.gmail.com',
            auth: {
                user: process.env.CONTACTEMAIL,
                pass: process.env.PASSWORDEMAIL
            }
        }));

        const mailOptions = {
            from: 'contactengrainonsnous@gmail.com',
            to: body.email,
            subject: 'New password',
            text: `Your new password is: ${body.password} `
        };

        transporter.sendMail(mailOptions, function (error, info) {
            if (error) {
                console.log(error);
            } else {
                console.log('Email sent: ' + info.response);
            }
        });
    
    }
}