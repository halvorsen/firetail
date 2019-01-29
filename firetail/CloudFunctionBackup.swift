//
//  CloudFunctionBackup.swift
//  firetail
//
//  Created by Aaron Halvorsen on 10/5/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//

/*
alert trigger-
index.js

-'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const request = require('request-promise');

const ALERT_WEBHOOK_URL = 'https://script.google.com/macros/s/AKfycbz3CIGMywCquYTth9vTSLwL1x4UdGPR7VVRzzpXn0Q8FCJD0pVo/exec';
const ACCOUNTS_WEBHOOK_URL = 'https://script.google.com/macros/s/AKfycbyHpj3lUo6EHQanwA3j-aiIFZiQCVKWWzlwvXjoSCFG_kqCvCZl/exec';

admin.initializeApp(functions.config().firebase);

exports.webhookAlerts = functions.database.ref('/alerts/{alertID}').onCreate(event => {
    return request({
        uri: ALERT_WEBHOOK_URL,
        method: 'POST',
        json: true,
        body: event.data.val(),
        resolveWithFullResponse: true
    }).then(response => {
        if (response.statusCode >= 400) {
            throw new Error(`HTTP Error: ${response.statusCode}`);
        }
        });
    });

exports.webhookUsers = functions.database.ref('/users/{user}').onCreate(event => {
    return request({
        uri: ACCOUNTS_WEBHOOK_URL,
        method: 'POST',
        json: true,
        body: event.data.val(),
        resolveWithFullResponse: true
    }).then(response => {
        if (response.statusCode >= 400) {
            throw new Error(`HTTP Error: ${response.statusCode}`);
        }
        });
    });

exports.alertTrigger = functions.database.ref('/alerts/{alertID}/triggered/').onWrite(event => {
    const alertID = event.params.alertID;
    
    console.log('We have a new alert triggered:', alertID);
    // Get the list of device notification tokens.
    const _alertRef = admin.database().ref(`/alerts/${alertID}`).once('value');
    
    admin.database().ref(`/alerts/${alertID}`).once('value').then(function(snapshotAlert) {
        
        var alertSnap = snapshotAlert.val();
        
        const id = alertSnap.id;
        const tic = alertSnap.ticker;
        const user = alertSnap.username;
        const push = alertSnap.push;
        const urgent = alertSnap.urgent;
        const triggered = alertSnap.triggered;
        const alertPrice = alertSnap.priceString;
        const greaterThan = alertSnap.isGreaterThan;
        var isGThan = '📉';
        if (greaterThan) {
            isGThan = '📈'
        };
        
        console.log('ID:', id);
        console.log('ticker:', tic);
        console.log('username:', user);
        console.log('push Bool:', push);
        console.log('urgent Bool:', urgent);
        console.log('triggered Bool:', triggered);
        console.log('alert Price:', alertPrice);
        console.log('isGThan:', isGThan);
        
        admin.database().ref(`/users/${user}`).once('value').then(function(snapshotUser) {
            var userSnap = snapshotUser.val();
            const token = userSnap.token;
            console.log('my snap:', userSnap);
            console.log('my token:', token);
            
            if (push == true && triggered == "TRUE") {
                
                console.log('entered if loop')
                const payload = {
                    notification: {
                        //title: 'Stock Alert!',
                        title: '',
                        body: `${tic} ${isGThan} ${alertPrice}`
                        //body: '$' + `${tic} ${alertPrice}.`,
                    }
                };
                
                admin.messaging().sendToDevice(token, payload).then(response => {
                    console.log('entered message loop')
                    
                    response.results.forEach((result, index) => {
                        console.log(Date.now())
                        
                        const error = result.error;
                        if (error) {
                            console.error('Failure sending notification to', token, error);
                            // Cleanup the tokens who are not registered anymore.
                            console.log('error code', error.code)
                        }
                        });
                    
                    // console.log("Successfully sent message:", response);
                    });
                // .catch(function(error) {
                //   console.log("Error sending message:", error);
                // });
                
            }
            
            if (triggered == "TRUE") {
                return admin.database().ref(`/alerts/${alertID}`).once('value').then(function(snapshot) {
                    console.log('entered timestamp loop')
                    const _deleted = snapshot.val().deleted;
                    const _email = snapshot.val().email;
                    const _flash = snapshot.val().flash;
                    const _id = snapshot.val().id;
                    const _isGreaterThan = snapshot.val().isGreaterThan;
                    const _price = snapshot.val().price;
                    const _priceString = snapshot.val().priceString;
                    const _push = snapshot.val().push;
                    const _sms = snapshot.val().sms;
                    const _ticker = snapshot.val().ticker;
                    const _triggered = snapshot.val().triggered;
                    const _urgent = snapshot.val().urgent;
                    const _username = snapshot.val().username;
                    const _data2 = ""
                    
                    admin.database().ref(`/alerts/${alertID}`).set({
                        
                        data1: Date.now(),
                        data2: _data2,
                        data3: _data2,
                        data4: _data2,
                        data5: _data2,
                        deleted: _deleted,
                        email: _email,
                        flash: _flash,
                        id: _id,
                        isGreaterThan: _isGreaterThan,
                        price: _price,
                        priceString: _priceString,
                        push: _push,
                        sms: _sms,
                        ticker: _ticker,
                        triggered: _triggered,
                        urgent: _urgent,
                        username: _username
                    });
                });
            }
            
        });
        
    });
    });

 {
 "name": "functions",
 "requires": true,
 "lockfileVersion": 1,
 "dependencies": {
 "@types/express": {
 "version": "4.0.36",
 "resolved": "https://registry.npmjs.org/@types/express/-/express-4.0.36.tgz",
 "integrity": "sha512-bT9q2eqH/E72AGBQKT50dh6AXzheTqigGZ1GwDiwmx7vfHff0bZOrvUWjvGpNWPNkRmX1vDF6wonG6rlpBHb1A==",
 "requires": {
 "@types/express-serve-static-core": "4.0.49",
 "@types/serve-static": "1.7.31"
 }
 },
 "@types/express-serve-static-core": {
 "version": "4.0.49",
 "resolved": "https://registry.npmjs.org/@types/express-serve-static-core/-/express-serve-static-core-4.0.49.tgz",
 "integrity": "sha512-b7mVHoURu1xaP/V6xw1sYwyv9V0EZ7euyi+sdnbnTZxEkAh4/hzPsI6Eflq+ZzHQ/Tgl7l16Jz+0oz8F46MLnA==",
 "requires": {
 "@types/node": "8.0.14"
 }
 },
 "@types/jsonwebtoken": {
 "version": "7.2.2",
 "resolved": "https://registry.npmjs.org/@types/jsonwebtoken/-/jsonwebtoken-7.2.2.tgz",
 "integrity": "sha512-T2kcdrbS8dE94dnsaMVbIc/ENrCpIEByUqyc8Qa1mc04E8iVO/I6lsyTyGn+rV7Zo2+8gg/7P+lXDoLGFLwSKg==",
 "requires": {
 "@types/node": "8.0.14"
 }
 },
 "@types/lodash": {
 "version": "4.14.70",
 "resolved": "https://registry.npmjs.org/@types/lodash/-/lodash-4.14.70.tgz",
 "integrity": "sha512-uvDjWW3m7SFUhSpohfQvj32gRsVgRxA0Z0OfMJh8m/JuX4YJLHeEwRBuHJgvNgTAVBpJDFKVFeyrREuMwkE9Qw=="
 },
 "@types/mime": {
 "version": "1.3.1",
 "resolved": "https://registry.npmjs.org/@types/mime/-/mime-1.3.1.tgz",
 "integrity": "sha512-rek8twk9C58gHYqIrUlJsx8NQMhlxqHzln9Z9ODqiNgv3/s+ZwIrfr+djqzsnVM12xe9hL98iJ20lj2RvCBv6A=="
 },
 "@types/node": {
 "version": "8.0.14",
 "resolved": "https://registry.npmjs.org/@types/node/-/node-8.0.14.tgz",
 "integrity": "sha512-lrtgE/5FeTdcuxgsDbLUIFJ33dTp4TkbKkTDZt/ueUMeqmGYqJRQd908q5Yj9EzzWSMonEhMr1q/CQlgVGEt4w=="
 },
 "@types/serve-static": {
 "version": "1.7.31",
 "resolved": "https://registry.npmjs.org/@types/serve-static/-/serve-static-1.7.31.tgz",
 "integrity": "sha1-FUVt6NmNa0z/Mb5savdJKuY/Uho=",
 "requires": {
 "@types/express-serve-static-core": "4.0.49",
 "@types/mime": "1.3.1"
 }
 },
 "@types/sha1": {
 "version": "1.1.0",
 "resolved": "https://registry.npmjs.org/@types/sha1/-/sha1-1.1.0.tgz",
 "integrity": "sha1-Rh6xiQbSXo0HxGeKDtT5ygfkbdk=",
 "requires": {
 "@types/node": "8.0.14"
 }
 },
 "accepts": {
 "version": "1.3.3",
 "resolved": "https://registry.npmjs.org/accepts/-/accepts-1.3.3.tgz",
 "integrity": "sha1-w8p0NJOGSMPg2cHjKN1otiLChMo=",
 "requires": {
 "mime-types": "2.1.15",
 "negotiator": "0.6.1"
 }
 },
 "ajv": {
 "version": "4.11.8",
 "resolved": "https://registry.npmjs.org/ajv/-/ajv-4.11.8.tgz",
 "integrity": "sha1-gv+wKynmYq5TvcIK8VlHcGc5xTY=",
 "requires": {
 "co": "4.6.0",
 "json-stable-stringify": "1.0.1"
 }
 },
 "array-flatten": {
 "version": "1.1.1",
 "resolved": "https://registry.npmjs.org/array-flatten/-/array-flatten-1.1.1.tgz",
 "integrity": "sha1-ml9pkFGx5wczKPKgCJaLZOopVdI="
 },
 "asn1": {
 "version": "0.2.3",
 "resolved": "https://registry.npmjs.org/asn1/-/asn1-0.2.3.tgz",
 "integrity": "sha1-2sh4dxPJlmhJ/IGAd36+nB3fO4Y="
 },
 "assert-plus": {
 "version": "0.2.0",
 "resolved": "https://registry.npmjs.org/assert-plus/-/assert-plus-0.2.0.tgz",
 "integrity": "sha1-104bh+ev/A24qttwIfP+SBAasjQ="
 },
 "asynckit": {
 "version": "0.4.0",
 "resolved": "https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz",
 "integrity": "sha1-x57Zf380y48robyXkLzDZkdLS3k="
 },
 "aws-sign2": {
 "version": "0.6.0",
 "resolved": "https://registry.npmjs.org/aws-sign2/-/aws-sign2-0.6.0.tgz",
 "integrity": "sha1-FDQt0428yU0OW4fXY81jYSwOeU8="
 },
 "aws4": {
 "version": "1.6.0",
 "resolved": "https://registry.npmjs.org/aws4/-/aws4-1.6.0.tgz",
 "integrity": "sha1-g+9cqGCysy5KDe7e6MdxudtXRx4="
 },
 "base64url": {
 "version": "2.0.0",
 "resolved": "https://registry.npmjs.org/base64url/-/base64url-2.0.0.tgz",
 "integrity": "sha1-6sFuA+oUOO/5Qj1puqNiYu0fcLs="
 },
 "bcrypt-pbkdf": {
 "version": "1.0.1",
 "resolved": "https://registry.npmjs.org/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.1.tgz",
 "integrity": "sha1-Y7xdy2EzG5K8Bf1SiVPDNGKgb40=",
 "optional": true,
 "requires": {
 "tweetnacl": "0.14.5"
 }
 },
 "bluebird": {
 "version": "3.5.0",
 "resolved": "https://registry.npmjs.org/bluebird/-/bluebird-3.5.0.tgz",
 "integrity": "sha1-eRQg1/VR7qKJdFOop3ZT+WYG1nw="
 },
 "boom": {
 "version": "2.10.1",
 "resolved": "https://registry.npmjs.org/boom/-/boom-2.10.1.tgz",
 "integrity": "sha1-OciRjO/1eZ+D+UkqhI9iWt0Mdm8=",
 "requires": {
 "hoek": "2.16.3"
 }
 },
 "buffer-equal-constant-time": {
 "version": "1.0.1",
 "resolved": "https://registry.npmjs.org/buffer-equal-constant-time/-/buffer-equal-constant-time-1.0.1.tgz",
 "integrity": "sha1-+OcRMvf/5uAaXJaXpMbz5I1cyBk="
 },
 "caseless": {
 "version": "0.12.0",
 "resolved": "https://registry.npmjs.org/caseless/-/caseless-0.12.0.tgz",
 "integrity": "sha1-G2gcIf+EAzyCZUMJBolCDRhxUdw="
 },
 "charenc": {
 "version": "0.0.2",
 "resolved": "https://registry.npmjs.org/charenc/-/charenc-0.0.2.tgz",
 "integrity": "sha1-wKHS86cJLgN3S/qD8UwPxXkKhmc="
 },
 "co": {
 "version": "4.6.0",
 "resolved": "https://registry.npmjs.org/co/-/co-4.6.0.tgz",
 "integrity": "sha1-bqa989hTrlTMuOR7+gvz+QMfsYQ="
 },
 "combined-stream": {
 "version": "1.0.5",
 "resolved": "https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.5.tgz",
 "integrity": "sha1-k4NwpXtKUd6ix3wV1cX9+JUWQAk=",
 "requires": {
 "delayed-stream": "1.0.0"
 }
 },
 "content-disposition": {
 "version": "0.5.2",
 "resolved": "https://registry.npmjs.org/content-disposition/-/content-disposition-0.5.2.tgz",
 "integrity": "sha1-DPaLud318r55YcOoUXjLhdunjLQ="
 },
 "content-type": {
 "version": "1.0.2",
 "resolved": "https://registry.npmjs.org/content-type/-/content-type-1.0.2.tgz",
 "integrity": "sha1-t9ETrueo3Se9IRM8TcJSnfFyHu0="
 },
 "cookie": {
 "version": "0.3.1",
 "resolved": "https://registry.npmjs.org/cookie/-/cookie-0.3.1.tgz",
 "integrity": "sha1-5+Ch+e9DtMi6klxcWpboBtFoc7s="
 },
 "cookie-signature": {
 "version": "1.0.6",
 "resolved": "https://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.6.tgz",
 "integrity": "sha1-4wOogrNCzD7oylE6eZmXNNqzriw="
 },
 "crypt": {
 "version": "0.0.2",
 "resolved": "https://registry.npmjs.org/crypt/-/crypt-0.0.2.tgz",
 "integrity": "sha1-iNf/fsDfuG9xPch7u0LQRNPmxBs="
 },
 "cryptiles": {
 "version": "2.0.5",
 "resolved": "https://registry.npmjs.org/cryptiles/-/cryptiles-2.0.5.tgz",
 "integrity": "sha1-O9/s3GCBR8HGcgL6KR59ylnqo7g=",
 "requires": {
 "boom": "2.10.1"
 }
 },
 "dashdash": {
 "version": "1.14.1",
 "resolved": "https://registry.npmjs.org/dashdash/-/dashdash-1.14.1.tgz",
 "integrity": "sha1-hTz6D3y+L+1d4gMmuN1YEDX24vA=",
 "requires": {
 "assert-plus": "1.0.0"
 },
 "dependencies": {
 "assert-plus": {
 "version": "1.0.0",
 "resolved": "https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz",
 "integrity": "sha1-8S4PPF13sLHN2RRpQuTpbB5N1SU="
 }
 }
 },
 "debug": {
 "version": "2.6.7",
 "resolved": "https://registry.npmjs.org/debug/-/debug-2.6.7.tgz",
 "integrity": "sha1-krrR9tBbu2u6Isyoi80OyJTChh4=",
 "requires": {
 "ms": "2.0.0"
 }
 },
 "delayed-stream": {
 "version": "1.0.0",
 "resolved": "https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz",
 "integrity": "sha1-3zrhmayt+31ECqrgsp4icrJOxhk="
 },
 "depd": {
 "version": "1.1.0",
 "resolved": "https://registry.npmjs.org/depd/-/depd-1.1.0.tgz",
 "integrity": "sha1-4b2Cxqq2ztlluXuIsX7T5SjKGMM="
 },
 "destroy": {
 "version": "1.0.4",
 "resolved": "https://registry.npmjs.org/destroy/-/destroy-1.0.4.tgz",
 "integrity": "sha1-l4hXRCxEdJ5CBmE+N5RiBYJqvYA="
 },
 "ecc-jsbn": {
 "version": "0.1.1",
 "resolved": "https://registry.npmjs.org/ecc-jsbn/-/ecc-jsbn-0.1.1.tgz",
 "integrity": "sha1-D8c6ntXw1Tw4GTOYUj735UN3dQU=",
 "optional": true,
 "requires": {
 "jsbn": "0.1.1"
 }
 },
 "ecdsa-sig-formatter": {
 "version": "1.0.9",
 "resolved": "https://registry.npmjs.org/ecdsa-sig-formatter/-/ecdsa-sig-formatter-1.0.9.tgz",
 "integrity": "sha1-S8kmJ07Dtau1AW5+HWCSGsJisqE=",
 "requires": {
 "base64url": "2.0.0",
 "safe-buffer": "5.1.1"
 }
 },
 "ee-first": {
 "version": "1.1.1",
 "resolved": "https://registry.npmjs.org/ee-first/-/ee-first-1.1.1.tgz",
 "integrity": "sha1-WQxhFWsK4vTwJVcyoViyZrxWsh0="
 },
 "encodeurl": {
 "version": "1.0.1",
 "resolved": "https://registry.npmjs.org/encodeurl/-/encodeurl-1.0.1.tgz",
 "integrity": "sha1-eePVhlU0aQn+bw9Fpd5oEDspTSA="
 },
 "escape-html": {
 "version": "1.0.3",
 "resolved": "https://registry.npmjs.org/escape-html/-/escape-html-1.0.3.tgz",
 "integrity": "sha1-Aljq5NPQwJdN4cFpGI7wBR0dGYg="
 },
 "etag": {
 "version": "1.8.0",
 "resolved": "https://registry.npmjs.org/etag/-/etag-1.8.0.tgz",
 "integrity": "sha1-b2Ma7zNtbEY2K1F2QETOIWvjwFE="
 },
 "express": {
 "version": "4.15.3",
 "resolved": "https://registry.npmjs.org/express/-/express-4.15.3.tgz",
 "integrity": "sha1-urZdDwOqgMNYQIly/HAPkWlEtmI=",
 "requires": {
 "accepts": "1.3.3",
 "array-flatten": "1.1.1",
 "content-disposition": "0.5.2",
 "content-type": "1.0.2",
 "cookie": "0.3.1",
 "cookie-signature": "1.0.6",
 "debug": "2.6.7",
 "depd": "1.1.0",
 "encodeurl": "1.0.1",
 "escape-html": "1.0.3",
 "etag": "1.8.0",
 "finalhandler": "1.0.3",
 "fresh": "0.5.0",
 "merge-descriptors": "1.0.1",
 "methods": "1.1.2",
 "on-finished": "2.3.0",
 "parseurl": "1.3.1",
 "path-to-regexp": "0.1.7",
 "proxy-addr": "1.1.4",
 "qs": "6.4.0",
 "range-parser": "1.2.0",
 "send": "0.15.3",
 "serve-static": "1.12.3",
 "setprototypeof": "1.0.3",
 "statuses": "1.3.1",
 "type-is": "1.6.15",
 "utils-merge": "1.0.0",
 "vary": "1.1.1"
 }
 },
 "extend": {
 "version": "3.0.1",
 "resolved": "https://registry.npmjs.org/extend/-/extend-3.0.1.tgz",
 "integrity": "sha1-p1Xqe8Gt/MWjHOfnYtuq3F5jZEQ="
 },
 "extsprintf": {
 "version": "1.0.2",
 "resolved": "https://registry.npmjs.org/extsprintf/-/extsprintf-1.0.2.tgz",
 "integrity": "sha1-4QgOBljjALBilJkMxw4VAiNf1VA="
 },
 "finalhandler": {
 "version": "1.0.3",
 "resolved": "https://registry.npmjs.org/finalhandler/-/finalhandler-1.0.3.tgz",
 "integrity": "sha1-70fneVDpmXgOhgIqVg4yF+DQzIk=",
 "requires": {
 "debug": "2.6.7",
 "encodeurl": "1.0.1",
 "escape-html": "1.0.3",
 "on-finished": "2.3.0",
 "parseurl": "1.3.1",
 "statuses": "1.3.1",
 "unpipe": "1.0.0"
 }
 },
 "firebase-admin": {
 "version": "4.2.1",
 "resolved": "https://registry.npmjs.org/firebase-admin/-/firebase-admin-4.2.1.tgz",
 "integrity": "sha1-kXlL/CFO4h3sx2XTCEERZqBcCyA=",
 "requires": {
 "@types/jsonwebtoken": "7.2.0",
 "faye-websocket": "0.9.3",
 "jsonwebtoken": "7.1.9"
 },
 "dependencies": {
 "@types/jsonwebtoken": {
 "version": "7.2.0",
 "resolved": "https://registry.npmjs.org/@types/jsonwebtoken/-/jsonwebtoken-7.2.0.tgz",
 "integrity": "sha1-D+0yyFAdqArJg50tQDplyD13b/0=",
 "requires": {
 "@types/node": "7.0.12"
 }
 },
 "@types/node": {
 "version": "7.0.12",
 "resolved": "https://registry.npmjs.org/@types/node/-/node-7.0.12.tgz",
 "integrity": "sha1-rl9noZwV91IUgATbB8u7Ny5p78k="
 },
 "base64url": {
 "version": "2.0.0",
 "resolved": "https://registry.npmjs.org/base64url/-/base64url-2.0.0.tgz",
 "integrity": "sha1-6sFuA+oUOO/5Qj1puqNiYu0fcLs="
 },
 "buffer-equal-constant-time": {
 "version": "1.0.1",
 "resolved": "https://registry.npmjs.org/buffer-equal-constant-time/-/buffer-equal-constant-time-1.0.1.tgz",
 "integrity": "sha1-+OcRMvf/5uAaXJaXpMbz5I1cyBk="
 },
 "ecdsa-sig-formatter": {
 "version": "1.0.9",
 "resolved": "https://registry.npmjs.org/ecdsa-sig-formatter/-/ecdsa-sig-formatter-1.0.9.tgz",
 "integrity": "sha1-S8kmJ07Dtau1AW5+HWCSGsJisqE=",
 "requires": {
 "base64url": "2.0.0",
 "safe-buffer": "5.0.1"
 }
 },
 "faye-websocket": {
 "version": "0.9.3",
 "resolved": "https://registry.npmjs.org/faye-websocket/-/faye-websocket-0.9.3.tgz",
 "integrity": "sha1-SCpQWw3wrmJrlphm0710DNuWLoM=",
 "requires": {
 "websocket-driver": "0.6.5"
 }
 },
 "hoek": {
 "version": "2.16.3",
 "resolved": "https://registry.npmjs.org/hoek/-/hoek-2.16.3.tgz",
 "integrity": "sha1-ILt0A9POo5jpHcRxCo/xuCdKJe0="
 },
 "isemail": {
 "version": "1.2.0",
 "resolved": "https://registry.npmjs.org/isemail/-/isemail-1.2.0.tgz",
 "integrity": "sha1-vgPfjMPineTSxd9lASY/H6RZXpo="
 },
 "joi": {
 "version": "6.10.1",
 "resolved": "https://registry.npmjs.org/joi/-/joi-6.10.1.tgz",
 "integrity": "sha1-TVDDGAeRIgAP5fFq8f+OGRe3fgY=",
 "requires": {
 "hoek": "2.16.3",
 "isemail": "1.2.0",
 "moment": "2.18.1",
 "topo": "1.1.0"
 }
 },
 "jsonwebtoken": {
 "version": "7.1.9",
 "resolved": "https://registry.npmjs.org/jsonwebtoken/-/jsonwebtoken-7.1.9.tgz",
 "integrity": "sha1-hHgE5SWL7FqUmajcSl56O64I1Yo=",
 "requires": {
 "joi": "6.10.1",
 "jws": "3.1.4",
 "lodash.once": "4.1.1",
 "ms": "0.7.3",
 "xtend": "4.0.1"
 }
 },
 "jwa": {
 "version": "1.1.5",
 "resolved": "https://registry.npmjs.org/jwa/-/jwa-1.1.5.tgz",
 "integrity": "sha1-oFUs4CIHQs1S4VN3SjKQXDDnVuU=",
 "requires": {
 "base64url": "2.0.0",
 "buffer-equal-constant-time": "1.0.1",
 "ecdsa-sig-formatter": "1.0.9",
 "safe-buffer": "5.0.1"
 }
 },
 "jws": {
 "version": "3.1.4",
 "resolved": "https://registry.npmjs.org/jws/-/jws-3.1.4.tgz",
 "integrity": "sha1-+ei5M46KhHJ31kRLFGT2GIDgUKI=",
 "requires": {
 "base64url": "2.0.0",
 "jwa": "1.1.5",
 "safe-buffer": "5.0.1"
 }
 },
 "lodash.once": {
 "version": "4.1.1",
 "resolved": "https://registry.npmjs.org/lodash.once/-/lodash.once-4.1.1.tgz",
 "integrity": "sha1-DdOXEhPHxW34gJd9UEyI+0cal6w="
 },
 "moment": {
 "version": "2.18.1",
 "resolved": "https://registry.npmjs.org/moment/-/moment-2.18.1.tgz",
 "integrity": "sha1-w2GT3Tzhwu7SrbfIAtu8d6gbHA8="
 },
 "ms": {
 "version": "0.7.3",
 "resolved": "https://registry.npmjs.org/ms/-/ms-0.7.3.tgz",
 "integrity": "sha1-cIFVpeROM/X9D8U+gdDUCpG+H/8="
 },
 "safe-buffer": {
 "version": "5.0.1",
 "resolved": "https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.0.1.tgz",
 "integrity": "sha1-0mPKVGls2KMGtcplUekt5XkY++c="
 },
 "topo": {
 "version": "1.1.0",
 "resolved": "https://registry.npmjs.org/topo/-/topo-1.1.0.tgz",
 "integrity": "sha1-6ddRYV0buH3IZdsYL6HKCl71NtU=",
 "requires": {
 "hoek": "2.16.3"
 }
 },
 "websocket-driver": {
 "version": "0.6.5",
 "resolved": "https://registry.npmjs.org/websocket-driver/-/websocket-driver-0.6.5.tgz",
 "integrity": "sha1-XLJVbOuF9Dc8bYI4qmkchFThOjY=",
 "requires": {
 "websocket-extensions": "0.1.1"
 }
 },
 "websocket-extensions": {
 "version": "0.1.1",
 "resolved": "https://registry.npmjs.org/websocket-extensions/-/websocket-extensions-0.1.1.tgz",
 "integrity": "sha1-domUmcGEtu91Q3fC27DNbLVdKec="
 },
 "xtend": {
 "version": "4.0.1",
 "resolved": "https://registry.npmjs.org/xtend/-/xtend-4.0.1.tgz",
 "integrity": "sha1-pcbVMr5lbiPbgg77lDofBJmNY68="
 }
 }
 },
 "firebase-functions": {
 "version": "0.5.9",
 "resolved": "https://registry.npmjs.org/firebase-functions/-/firebase-functions-0.5.9.tgz",
 "integrity": "sha1-dBVcP7QvO7FalXkzEWZNFL9hCno=",
 "requires": {
 "@types/express": "4.0.36",
 "@types/jsonwebtoken": "7.2.2",
 "@types/lodash": "4.14.70",
 "@types/sha1": "1.1.0",
 "express": "4.15.3",
 "jsonwebtoken": "7.4.1",
 "lodash": "4.17.4",
 "sha1": "1.1.1"
 }
 },
 "forever-agent": {
 "version": "0.6.1",
 "resolved": "https://registry.npmjs.org/forever-agent/-/forever-agent-0.6.1.tgz",
 "integrity": "sha1-+8cfDEGt6zf5bFd60e1C2P2sypE="
 },
 "form-data": {
 "version": "2.1.4",
 "resolved": "https://registry.npmjs.org/form-data/-/form-data-2.1.4.tgz",
 "integrity": "sha1-M8GDrPGTJ27KqYFDpp6Uv+4XUNE=",
 "requires": {
 "asynckit": "0.4.0",
 "combined-stream": "1.0.5",
 "mime-types": "2.1.15"
 }
 },
 "forwarded": {
 "version": "0.1.0",
 "resolved": "https://registry.npmjs.org/forwarded/-/forwarded-0.1.0.tgz",
 "integrity": "sha1-Ge+YdMSuHCl7zweP3mOgm2aoQ2M="
 },
 "fresh": {
 "version": "0.5.0",
 "resolved": "https://registry.npmjs.org/fresh/-/fresh-0.5.0.tgz",
 "integrity": "sha1-9HTKXmqSRtb9jglTz6m5yAWvp44="
 },
 "getpass": {
 "version": "0.1.7",
 "resolved": "https://registry.npmjs.org/getpass/-/getpass-0.1.7.tgz",
 "integrity": "sha1-Xv+OPmhNVprkyysSgmBOi6YhSfo=",
 "requires": {
 "assert-plus": "1.0.0"
 },
 "dependencies": {
 "assert-plus": {
 "version": "1.0.0",
 "resolved": "https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz",
 "integrity": "sha1-8S4PPF13sLHN2RRpQuTpbB5N1SU="
 }
 }
 },
 "har-schema": {
 "version": "1.0.5",
 "resolved": "https://registry.npmjs.org/har-schema/-/har-schema-1.0.5.tgz",
 "integrity": "sha1-0mMTX0MwfALGAq/I/pWXDAFRNp4="
 },
 "har-validator": {
 "version": "4.2.1",
 "resolved": "https://registry.npmjs.org/har-validator/-/har-validator-4.2.1.tgz",
 "integrity": "sha1-M0gdDxu/9gDdID11gSpqX7oALio=",
 "requires": {
 "ajv": "4.11.8",
 "har-schema": "1.0.5"
 }
 },
 "hawk": {
 "version": "3.1.3",
 "resolved": "https://registry.npmjs.org/hawk/-/hawk-3.1.3.tgz",
 "integrity": "sha1-B4REvXwWQLD+VA0sm3PVlnjo4cQ=",
 "requires": {
 "boom": "2.10.1",
 "cryptiles": "2.0.5",
 "hoek": "2.16.3",
 "sntp": "1.0.9"
 }
 },
 "hoek": {
 "version": "2.16.3",
 "resolved": "https://registry.npmjs.org/hoek/-/hoek-2.16.3.tgz",
 "integrity": "sha1-ILt0A9POo5jpHcRxCo/xuCdKJe0="
 },
 "http-errors": {
 "version": "1.6.1",
 "resolved": "https://registry.npmjs.org/http-errors/-/http-errors-1.6.1.tgz",
 "integrity": "sha1-X4uO2YrKVFZWv1cplzh/kEpyIlc=",
 "requires": {
 "depd": "1.1.0",
 "inherits": "2.0.3",
 "setprototypeof": "1.0.3",
 "statuses": "1.3.1"
 }
 },
 "http-signature": {
 "version": "1.1.1",
 "resolved": "https://registry.npmjs.org/http-signature/-/http-signature-1.1.1.tgz",
 "integrity": "sha1-33LiZwZs0Kxn+3at+OE0qPvPkb8=",
 "requires": {
 "assert-plus": "0.2.0",
 "jsprim": "1.4.0",
 "sshpk": "1.13.1"
 }
 },
 "inherits": {
 "version": "2.0.3",
 "resolved": "https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz",
 "integrity": "sha1-Yzwsg+PaQqUC9SRmAiSA9CCCYd4="
 },
 "ipaddr.js": {
 "version": "1.3.0",
 "resolved": "https://registry.npmjs.org/ipaddr.js/-/ipaddr.js-1.3.0.tgz",
 "integrity": "sha1-HgOlL9rYOou7KyXL9JmLTP/NPew="
 },
 "is-typedarray": {
 "version": "1.0.0",
 "resolved": "https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz",
 "integrity": "sha1-5HnICFjfDBsR3dppQPlgEfzaSpo="
 },
 "isemail": {
 "version": "1.2.0",
 "resolved": "https://registry.npmjs.org/isemail/-/isemail-1.2.0.tgz",
 "integrity": "sha1-vgPfjMPineTSxd9lASY/H6RZXpo="
 },
 "isstream": {
 "version": "0.1.2",
 "resolved": "https://registry.npmjs.org/isstream/-/isstream-0.1.2.tgz",
 "integrity": "sha1-R+Y/evVa+m+S4VAOaQ64uFKcCZo="
 },
 "joi": {
 "version": "6.10.1",
 "resolved": "https://registry.npmjs.org/joi/-/joi-6.10.1.tgz",
 "integrity": "sha1-TVDDGAeRIgAP5fFq8f+OGRe3fgY=",
 "requires": {
 "hoek": "2.16.3",
 "isemail": "1.2.0",
 "moment": "2.18.1",
 "topo": "1.1.0"
 }
 },
 "jsbn": {
 "version": "0.1.1",
 "resolved": "https://registry.npmjs.org/jsbn/-/jsbn-0.1.1.tgz",
 "integrity": "sha1-peZUwuWi3rXyAdls77yoDA7y9RM=",
 "optional": true
 },
 "json-schema": {
 "version": "0.2.3",
 "resolved": "https://registry.npmjs.org/json-schema/-/json-schema-0.2.3.tgz",
 "integrity": "sha1-tIDIkuWaLwWVTOcnvT8qTogvnhM="
 },
 "json-stable-stringify": {
 "version": "1.0.1",
 "resolved": "https://registry.npmjs.org/json-stable-stringify/-/json-stable-stringify-1.0.1.tgz",
 "integrity": "sha1-mnWdOcXy/1A/1TAGRu1EX4jE+a8=",
 "requires": {
 "jsonify": "0.0.0"
 }
 },
 "json-stringify-safe": {
 "version": "5.0.1",
 "resolved": "https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz",
 "integrity": "sha1-Epai1Y/UXxmg9s4B1lcB4sc1tus="
 },
 "jsonify": {
 "version": "0.0.0",
 "resolved": "https://registry.npmjs.org/jsonify/-/jsonify-0.0.0.tgz",
 "integrity": "sha1-LHS27kHZPKUbe1qu6PUDYx0lKnM="
 },
 "jsonwebtoken": {
 "version": "7.4.1",
 "resolved": "https://registry.npmjs.org/jsonwebtoken/-/jsonwebtoken-7.4.1.tgz",
 "integrity": "sha1-fKMk9SFfi+A5zTWmxFu4y3SkSPs=",
 "requires": {
 "joi": "6.10.1",
 "jws": "3.1.4",
 "lodash.once": "4.1.1",
 "ms": "2.0.0",
 "xtend": "4.0.1"
 }
 },
 "jsprim": {
 "version": "1.4.0",
 "resolved": "https://registry.npmjs.org/jsprim/-/jsprim-1.4.0.tgz",
 "integrity": "sha1-o7h+QCmNjDgFUtjMdiigu5WiKRg=",
 "requires": {
 "assert-plus": "1.0.0",
 "extsprintf": "1.0.2",
 "json-schema": "0.2.3",
 "verror": "1.3.6"
 },
 "dependencies": {
 "assert-plus": {
 "version": "1.0.0",
 "resolved": "https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz",
 "integrity": "sha1-8S4PPF13sLHN2RRpQuTpbB5N1SU="
 }
 }
 },
 "jwa": {
 "version": "1.1.5",
 "resolved": "https://registry.npmjs.org/jwa/-/jwa-1.1.5.tgz",
 "integrity": "sha1-oFUs4CIHQs1S4VN3SjKQXDDnVuU=",
 "requires": {
 "base64url": "2.0.0",
 "buffer-equal-constant-time": "1.0.1",
 "ecdsa-sig-formatter": "1.0.9",
 "safe-buffer": "5.1.1"
 }
 },
 "jws": {
 "version": "3.1.4",
 "resolved": "https://registry.npmjs.org/jws/-/jws-3.1.4.tgz",
 "integrity": "sha1-+ei5M46KhHJ31kRLFGT2GIDgUKI=",
 "requires": {
 "base64url": "2.0.0",
 "jwa": "1.1.5",
 "safe-buffer": "5.1.1"
 }
 },
 "lodash": {
 "version": "4.17.4",
 "resolved": "https://registry.npmjs.org/lodash/-/lodash-4.17.4.tgz",
 "integrity": "sha1-eCA6TRwyiuHYbcpkYONptX9AVa4="
 },
 "lodash.once": {
 "version": "4.1.1",
 "resolved": "https://registry.npmjs.org/lodash.once/-/lodash.once-4.1.1.tgz",
 "integrity": "sha1-DdOXEhPHxW34gJd9UEyI+0cal6w="
 },
 "media-typer": {
 "version": "0.3.0",
 "resolved": "https://registry.npmjs.org/media-typer/-/media-typer-0.3.0.tgz",
 "integrity": "sha1-hxDXrwqmJvj/+hzgAWhUUmMlV0g="
 },
 "merge-descriptors": {
 "version": "1.0.1",
 "resolved": "https://registry.npmjs.org/merge-descriptors/-/merge-descriptors-1.0.1.tgz",
 "integrity": "sha1-sAqqVW3YtEVoFQ7J0blT8/kMu2E="
 },
 "methods": {
 "version": "1.1.2",
 "resolved": "https://registry.npmjs.org/methods/-/methods-1.1.2.tgz",
 "integrity": "sha1-VSmk1nZUE07cxSZmVoNbD4Ua/O4="
 },
 "mime": {
 "version": "1.3.4",
 "resolved": "https://registry.npmjs.org/mime/-/mime-1.3.4.tgz",
 "integrity": "sha1-EV+eO2s9rylZmDyzjxSaLUDrXVM="
 },
 "mime-db": {
 "version": "1.27.0",
 "resolved": "https://registry.npmjs.org/mime-db/-/mime-db-1.27.0.tgz",
 "integrity": "sha1-gg9XIpa70g7CXtVeW13oaeVDbrE="
 },
 "mime-types": {
 "version": "2.1.15",
 "resolved": "https://registry.npmjs.org/mime-types/-/mime-types-2.1.15.tgz",
 "integrity": "sha1-pOv1BkCUVpI3uM9wBGd20J/JKu0=",
 "requires": {
 "mime-db": "1.27.0"
 }
 },
 "moment": {
 "version": "2.18.1",
 "resolved": "https://registry.npmjs.org/moment/-/moment-2.18.1.tgz",
 "integrity": "sha1-w2GT3Tzhwu7SrbfIAtu8d6gbHA8="
 },
 "ms": {
 "version": "2.0.0",
 "resolved": "https://registry.npmjs.org/ms/-/ms-2.0.0.tgz",
 "integrity": "sha1-VgiurfwAvmwpAd9fmGF4jeDVl8g="
 },
 "negotiator": {
 "version": "0.6.1",
 "resolved": "https://registry.npmjs.org/negotiator/-/negotiator-0.6.1.tgz",
 "integrity": "sha1-KzJxhOiZIQEXeyhWP7XnECrNDKk="
 },
 "oauth-sign": {
 "version": "0.8.2",
 "resolved": "https://registry.npmjs.org/oauth-sign/-/oauth-sign-0.8.2.tgz",
 "integrity": "sha1-Rqarfwrq2N6unsBWV4C31O/rnUM="
 },
 "on-finished": {
 "version": "2.3.0",
 "resolved": "https://registry.npmjs.org/on-finished/-/on-finished-2.3.0.tgz",
 "integrity": "sha1-IPEzZIGwg811M3mSoWlxqi2QaUc=",
 "requires": {
 "ee-first": "1.1.1"
 }
 },
 "parseurl": {
 "version": "1.3.1",
 "resolved": "https://registry.npmjs.org/parseurl/-/parseurl-1.3.1.tgz",
 "integrity": "sha1-yKuMkiO6NIiKpkopeyiFO+wY2lY="
 },
 "path-to-regexp": {
 "version": "0.1.7",
 "resolved": "https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.7.tgz",
 "integrity": "sha1-32BBeABfUi8V60SQ5yR6G/qmf4w="
 },
 "performance-now": {
 "version": "0.2.0",
 "resolved": "https://registry.npmjs.org/performance-now/-/performance-now-0.2.0.tgz",
 "integrity": "sha1-M+8wxcd9TqIcWlOGnZG1bY8lVeU="
 },
 "proxy-addr": {
 "version": "1.1.4",
 "resolved": "https://registry.npmjs.org/proxy-addr/-/proxy-addr-1.1.4.tgz",
 "integrity": "sha1-J+VF9pYKRKYn2bREZ+NcG2tM4vM=",
 "requires": {
 "forwarded": "0.1.0",
 "ipaddr.js": "1.3.0"
 }
 },
 "punycode": {
 "version": "1.4.1",
 "resolved": "https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz",
 "integrity": "sha1-wNWmOycYgArY4esPpSachN1BhF4="
 },
 "qs": {
 "version": "6.4.0",
 "resolved": "https://registry.npmjs.org/qs/-/qs-6.4.0.tgz",
 "integrity": "sha1-E+JtKK1rD/qpExLNO/cI7TUecjM="
 },
 "range-parser": {
 "version": "1.2.0",
 "resolved": "https://registry.npmjs.org/range-parser/-/range-parser-1.2.0.tgz",
 "integrity": "sha1-9JvmtIeJTdxA3MlKMi9hEJLgDV4="
 },
 "request": {
 "version": "2.81.0",
 "resolved": "https://registry.npmjs.org/request/-/request-2.81.0.tgz",
 "integrity": "sha1-xpKJRqDgbF+Nb4qTM0af/aRimKA=",
 "requires": {
 "aws-sign2": "0.6.0",
 "aws4": "1.6.0",
 "caseless": "0.12.0",
 "combined-stream": "1.0.5",
 "extend": "3.0.1",
 "forever-agent": "0.6.1",
 "form-data": "2.1.4",
 "har-validator": "4.2.1",
 "hawk": "3.1.3",
 "http-signature": "1.1.1",
 "is-typedarray": "1.0.0",
 "isstream": "0.1.2",
 "json-stringify-safe": "5.0.1",
 "mime-types": "2.1.15",
 "oauth-sign": "0.8.2",
 "performance-now": "0.2.0",
 "qs": "6.4.0",
 "safe-buffer": "5.1.1",
 "stringstream": "0.0.5",
 "tough-cookie": "2.3.2",
 "tunnel-agent": "0.6.0",
 "uuid": "3.1.0"
 }
 },
 "request-promise": {
 "version": "4.2.1",
 "resolved": "https://registry.npmjs.org/request-promise/-/request-promise-4.2.1.tgz",
 "integrity": "sha1-fuxWyJMXqCLL/qmbA5zlQ8LhX2c=",
 "requires": {
 "bluebird": "3.5.0",
 "request-promise-core": "1.1.1",
 "stealthy-require": "1.1.1",
 "tough-cookie": "2.3.2"
 }
 },
 "request-promise-core": {
 "version": "1.1.1",
 "resolved": "https://registry.npmjs.org/request-promise-core/-/request-promise-core-1.1.1.tgz",
 "integrity": "sha1-Pu4AssWqgyOc+wTFcA2jb4HNCLY=",
 "requires": {
 "lodash": "4.17.4"
 }
 },
 "safe-buffer": {
 "version": "5.1.1",
 "resolved": "https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.1.tgz",
 "integrity": "sha512-kKvNJn6Mm93gAczWVJg7wH+wGYWNrDHdWvpUmHyEsgCtIwwo3bqPtV4tR5tuPaUhTOo/kvhVwd8XwwOllGYkbg=="
 },
 "send": {
 "version": "0.15.3",
 "resolved": "https://registry.npmjs.org/send/-/send-0.15.3.tgz",
 "integrity": "sha1-UBP5+ZAj31DRvZiSwZ4979HVMwk=",
 "requires": {
 "debug": "2.6.7",
 "depd": "1.1.0",
 "destroy": "1.0.4",
 "encodeurl": "1.0.1",
 "escape-html": "1.0.3",
 "etag": "1.8.0",
 "fresh": "0.5.0",
 "http-errors": "1.6.1",
 "mime": "1.3.4",
 "ms": "2.0.0",
 "on-finished": "2.3.0",
 "range-parser": "1.2.0",
 "statuses": "1.3.1"
 }
 },
 "serve-static": {
 "version": "1.12.3",
 "resolved": "https://registry.npmjs.org/serve-static/-/serve-static-1.12.3.tgz",
 "integrity": "sha1-n0uhni8wMMVH+K+ZEHg47DjVseI=",
 "requires": {
 "encodeurl": "1.0.1",
 "escape-html": "1.0.3",
 "parseurl": "1.3.1",
 "send": "0.15.3"
 }
 },
 "setprototypeof": {
 "version": "1.0.3",
 "resolved": "https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.0.3.tgz",
 "integrity": "sha1-ZlZ+NwQ+608E2RvWWMDL77VbjgQ="
 },
 "sha1": {
 "version": "1.1.1",
 "resolved": "https://registry.npmjs.org/sha1/-/sha1-1.1.1.tgz",
 "integrity": "sha1-rdqnqTFo85PxnrKxUJFhjicA+Eg=",
 "requires": {
 "charenc": "0.0.2",
 "crypt": "0.0.2"
 }
 },
 "sntp": {
 "version": "1.0.9",
 "resolved": "https://registry.npmjs.org/sntp/-/sntp-1.0.9.tgz",
 "integrity": "sha1-ZUEYTMkK7qbG57NeJlkIJEPGYZg=",
 "requires": {
 "hoek": "2.16.3"
 }
 },
 "sshpk": {
 "version": "1.13.1",
 "resolved": "https://registry.npmjs.org/sshpk/-/sshpk-1.13.1.tgz",
 "integrity": "sha1-US322mKHFEMW3EwY/hzx2UBzm+M=",
 "requires": {
 "asn1": "0.2.3",
 "assert-plus": "1.0.0",
 "bcrypt-pbkdf": "1.0.1",
 "dashdash": "1.14.1",
 "ecc-jsbn": "0.1.1",
 "getpass": "0.1.7",
 "jsbn": "0.1.1",
 "tweetnacl": "0.14.5"
 },
 "dependencies": {
 "assert-plus": {
 "version": "1.0.0",
 "resolved": "https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz",
 "integrity": "sha1-8S4PPF13sLHN2RRpQuTpbB5N1SU="
 }
 }
 },
 "statuses": {
 "version": "1.3.1",
 "resolved": "https://registry.npmjs.org/statuses/-/statuses-1.3.1.tgz",
 "integrity": "sha1-+vUbnrdKrvOzrPStX2Gr8ky3uT4="
 },
 "stealthy-require": {
 "version": "1.1.1",
 "resolved": "https://registry.npmjs.org/stealthy-require/-/stealthy-require-1.1.1.tgz",
 "integrity": "sha1-NbCYdbT/SfJqd35QmzCQoyJr8ks="
 },
 "stringstream": {
 "version": "0.0.5",
 "resolved": "https://registry.npmjs.org/stringstream/-/stringstream-0.0.5.tgz",
 "integrity": "sha1-TkhM1N5aC7vuGORjB3EKioFiGHg="
 },
 "topo": {
 "version": "1.1.0",
 "resolved": "https://registry.npmjs.org/topo/-/topo-1.1.0.tgz",
 "integrity": "sha1-6ddRYV0buH3IZdsYL6HKCl71NtU=",
 "requires": {
 "hoek": "2.16.3"
 }
 },
 "tough-cookie": {
 "version": "2.3.2",
 "resolved": "https://registry.npmjs.org/tough-cookie/-/tough-cookie-2.3.2.tgz",
 "integrity": "sha1-8IH3bkyFcg5sN6X6ztc3FQ2EByo=",
 "requires": {
 "punycode": "1.4.1"
 }
 },
 "tunnel-agent": {
 "version": "0.6.0",
 "resolved": "https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.6.0.tgz",
 "integrity": "sha1-J6XeoGs2sEoKmWZ3SykIaPD8QP0=",
 "requires": {
 "safe-buffer": "5.1.1"
 }
 },
 "tweetnacl": {
 "version": "0.14.5",
 "resolved": "https://registry.npmjs.org/tweetnacl/-/tweetnacl-0.14.5.tgz",
 "integrity": "sha1-WuaBd/GS1EViadEIr6k/+HQ/T2Q=",
 "optional": true
 },
 "type-is": {
 "version": "1.6.15",
 "resolved": "https://registry.npmjs.org/type-is/-/type-is-1.6.15.tgz",
 "integrity": "sha1-yrEPtJCeRByChC6v4a1kbIGARBA=",
 "requires": {
 "media-typer": "0.3.0",
 "mime-types": "2.1.15"
 }
 },
 "unpipe": {
 "version": "1.0.0",
 "resolved": "https://registry.npmjs.org/unpipe/-/unpipe-1.0.0.tgz",
 "integrity": "sha1-sr9O6FFKrmFltIF4KdIbLvSZBOw="
 },
 "utils-merge": {
 "version": "1.0.0",
 "resolved": "https://registry.npmjs.org/utils-merge/-/utils-merge-1.0.0.tgz",
 "integrity": "sha1-ApT7kiu5N1FTVBxPcJYjHyh8ivg="
 },
 "uuid": {
 "version": "3.1.0",
 "resolved": "https://registry.npmjs.org/uuid/-/uuid-3.1.0.tgz",
 "integrity": "sha512-DIWtzUkw04M4k3bf1IcpS2tngXEL26YUD2M0tMDUpnUrz2hgzUBlD55a4FjdLGPvfHxS6uluGWvaVEqgBcVa+g=="
 },
 "vary": {
 "version": "1.1.1",
 "resolved": "https://registry.npmjs.org/vary/-/vary-1.1.1.tgz",
 "integrity": "sha1-Z1Neu2lMHVIldFeYRmUyP1h+jTc="
 },
 "verror": {
 "version": "1.3.6",
 "resolved": "https://registry.npmjs.org/verror/-/verror-1.3.6.tgz",
 "integrity": "sha1-z/XfEpRtKX0rqu+qJoniW+AcAFw=",
 "requires": {
 "extsprintf": "1.0.2"
 }
 },
 "xtend": {
 "version": "4.0.1",
 "resolved": "https://registry.npmjs.org/xtend/-/xtend-4.0.1.tgz",
 "integrity": "sha1-pcbVMr5lbiPbgg77lDofBJmNY68="
 }
 }
 }
 
// runtime config
 
 {
 "firebase": {
 "databaseURL": "https://firetail-db0ab.firebaseio.com",
 "storageBucket": "firetail-db0ab.appspot.com",
 "apiKey": "AIzaSyCqwBt0Bwo-z9Vbu9rrsBjsuKtCnWeQUa4",
 "authDomain": "firetail-db0ab.firebaseapp.com"
 }
 }
 
 package.json
 
 {
 "name": "functions",
 "description": "Cloud Functions for Firebase",
 "dependencies": {
 "firebase-admin": "~4.2.1",
 "firebase-functions": "^0.5.7",
 "request": "^2.81.0",
 "request-promise": "^4.2.1"
 },
 "private": true
 }
 
 webhook alerts:
 
 -'use strict';
 
 const functions = require('firebase-functions');
 const admin = require('firebase-admin');
 const request = require('request-promise');
 
 const ALERT_WEBHOOK_URL = 'https://script.google.com/macros/s/AKfycbz3CIGMywCquYTth9vTSLwL1x4UdGPR7VVRzzpXn0Q8FCJD0pVo/exec';
 const ACCOUNTS_WEBHOOK_URL = 'https://script.google.com/macros/s/AKfycbyHpj3lUo6EHQanwA3j-aiIFZiQCVKWWzlwvXjoSCFG_kqCvCZl/exec';
 
 admin.initializeApp(functions.config().firebase);
 
 exports.webhookAlerts = functions.database.ref('/alerts/{alertID}').onCreate(event => {
 return request({
 uri: ALERT_WEBHOOK_URL,
 method: 'POST',
 json: true,
 body: event.data.val(),
 resolveWithFullResponse: true
 }).then(response => {
 if (response.statusCode >= 400) {
 throw new Error(`HTTP Error: ${response.statusCode}`);
 }
 });
 });
 
 exports.webhookUsers = functions.database.ref('/users/{user}').onCreate(event => {
 return request({
 uri: ACCOUNTS_WEBHOOK_URL,
 method: 'POST',
 json: true,
 body: event.data.val(),
 resolveWithFullResponse: true
 }).then(response => {
 if (response.statusCode >= 400) {
 throw new Error(`HTTP Error: ${response.statusCode}`);
 }
 });
 });
 
 exports.alertTrigger = functions.database.ref('/alerts/{alertID}/triggered/').onWrite(event => {
 const alertID = event.params.alertID;
 
 console.log('We have a new alert triggered:', alertID);
 // Get the list of device notification tokens.
 const _alertRef = admin.database().ref(`/alerts/${alertID}`).once('value');
 
 admin.database().ref(`/alerts/${alertID}`).once('value').then(function(snapshotAlert) {
 
 var alertSnap = snapshotAlert.val();
 
 const id = alertSnap.id;
 const tic = alertSnap.ticker;
 const user = alertSnap.username;
 const push = alertSnap.push;
 const urgent = alertSnap.urgent;
 const triggered = alertSnap.triggered;
 const alertPrice = alertSnap.priceString;
 const greaterThan = alertSnap.isGreaterThan;
 var isGThan = '📉';
 if (greaterThan) {
 isGThan = '📈'
 };
 
 console.log('ID:', id);
 console.log('ticker:', tic);
 console.log('username:', user);
 console.log('push Bool:', push);
 console.log('urgent Bool:', urgent);
 console.log('triggered Bool:', triggered);
 console.log('alert Price:', alertPrice);
 console.log('isGThan:', isGThan);
 
 admin.database().ref(`/users/${user}`).once('value').then(function(snapshotUser) {
 var userSnap = snapshotUser.val();
 const token = userSnap.token;
 console.log('my snap:', userSnap);
 console.log('my token:', token);
 
 if (push == true && triggered == "TRUE") {
 
 console.log('entered if loop')
 const payload = {
 notification: {
 //title: 'Stock Alert!',
 title: '',
 body: `${tic} ${isGThan} ${alertPrice}`
 //body: '$' + `${tic} ${alertPrice}.`,
 }
 };
 
 admin.messaging().sendToDevice(token, payload).then(response => {
 console.log('entered message loop')
 
 response.results.forEach((result, index) => {
 console.log(Date.now())
 
 const error = result.error;
 if (error) {
 console.error('Failure sending notification to', token, error);
 // Cleanup the tokens who are not registered anymore.
 console.log('error code', error.code)
 }
 });
 
 // console.log("Successfully sent message:", response);
 });
 // .catch(function(error) {
 //   console.log("Error sending message:", error);
 // });
 
 }
 
 if (triggered == "TRUE") {
 return admin.database().ref(`/alerts/${alertID}`).once('value').then(function(snapshot) {
 console.log('entered timestamp loop')
 const _deleted = snapshot.val().deleted;
 const _email = snapshot.val().email;
 const _flash = snapshot.val().flash;
 const _id = snapshot.val().id;
 const _isGreaterThan = snapshot.val().isGreaterThan;
 const _price = snapshot.val().price;
 const _priceString = snapshot.val().priceString;
 const _push = snapshot.val().push;
 const _sms = snapshot.val().sms;
 const _ticker = snapshot.val().ticker;
 const _triggered = snapshot.val().triggered;
 const _urgent = snapshot.val().urgent;
 const _username = snapshot.val().username;
 const _data2 = ""
 
 admin.database().ref(`/alerts/${alertID}`).set({
 
 data1: Date.now(),
 data2: _data2,
 data3: _data2,
 data4: _data2,
 data5: _data2,
 deleted: _deleted,
 email: _email,
 flash: _flash,
 id: _id,
 isGreaterThan: _isGreaterThan,
 price: _price,
 priceString: _priceString,
 push: _push,
 sms: _sms,
 ticker: _ticker,
 triggered: _triggered,
 urgent: _urgent,
 username: _username
 });
 });
 }
 
 });
 
 });
 });
 
 webhook users:
 
 -'use strict';
 
 const functions = require('firebase-functions');
 const admin = require('firebase-admin');
 const request = require('request-promise');
 
 const ALERT_WEBHOOK_URL = 'https://script.google.com/macros/s/AKfycbz3CIGMywCquYTth9vTSLwL1x4UdGPR7VVRzzpXn0Q8FCJD0pVo/exec';
 const ACCOUNTS_WEBHOOK_URL = 'https://script.google.com/macros/s/AKfycbyHpj3lUo6EHQanwA3j-aiIFZiQCVKWWzlwvXjoSCFG_kqCvCZl/exec';
 
 admin.initializeApp(functions.config().firebase);
 
 exports.webhookAlerts = functions.database.ref('/alerts/{alertID}').onCreate(event => {
 return request({
 uri: ALERT_WEBHOOK_URL,
 method: 'POST',
 json: true,
 body: event.data.val(),
 resolveWithFullResponse: true
 }).then(response => {
 if (response.statusCode >= 400) {
 throw new Error(`HTTP Error: ${response.statusCode}`);
 }
 });
 });
 
 exports.webhookUsers = functions.database.ref('/users/{user}').onCreate(event => {
 return request({
 uri: ACCOUNTS_WEBHOOK_URL,
 method: 'POST',
 json: true,
 body: event.data.val(),
 resolveWithFullResponse: true
 }).then(response => {
 if (response.statusCode >= 400) {
 throw new Error(`HTTP Error: ${response.statusCode}`);
 }
 });
 });
 
 exports.alertTrigger = functions.database.ref('/alerts/{alertID}/triggered/').onWrite(event => {
 const alertID = event.params.alertID;
 
 console.log('We have a new alert triggered:', alertID);
 // Get the list of device notification tokens.
 const _alertRef = admin.database().ref(`/alerts/${alertID}`).once('value');
 
 admin.database().ref(`/alerts/${alertID}`).once('value').then(function(snapshotAlert) {
 
 var alertSnap = snapshotAlert.val();
 
 const id = alertSnap.id;
 const tic = alertSnap.ticker;
 const user = alertSnap.username;
 const push = alertSnap.push;
 const urgent = alertSnap.urgent;
 const triggered = alertSnap.triggered;
 const alertPrice = alertSnap.priceString;
 const greaterThan = alertSnap.isGreaterThan;
 var isGThan = '📉';
 if (greaterThan) {
 isGThan = '📈'
 };
 
 console.log('ID:', id);
 console.log('ticker:', tic);
 console.log('username:', user);
 console.log('push Bool:', push);
 console.log('urgent Bool:', urgent);
 console.log('triggered Bool:', triggered);
 console.log('alert Price:', alertPrice);
 console.log('isGThan:', isGThan);
 
 admin.database().ref(`/users/${user}`).once('value').then(function(snapshotUser) {
 var userSnap = snapshotUser.val();
 const token = userSnap.token;
 console.log('my snap:', userSnap);
 console.log('my token:', token);
 
 if (push == true && triggered == "TRUE") {
 
 console.log('entered if loop')
 const payload = {
 notification: {
 //title: 'Stock Alert!',
 title: '',
 body: `${tic} ${isGThan} ${alertPrice}`
 //body: '$' + `${tic} ${alertPrice}.`,
 }
 };
 
 admin.messaging().sendToDevice(token, payload).then(response => {
 console.log('entered message loop')
 
 response.results.forEach((result, index) => {
 console.log(Date.now())
 
 const error = result.error;
 if (error) {
 console.error('Failure sending notification to', token, error);
 // Cleanup the tokens who are not registered anymore.
 console.log('error code', error.code)
 }
 });
 
 // console.log("Successfully sent message:", response);
 });
 // .catch(function(error) {
 //   console.log("Error sending message:", error);
 // });
 
 }
 
 if (triggered == "TRUE") {
 return admin.database().ref(`/alerts/${alertID}`).once('value').then(function(snapshot) {
 console.log('entered timestamp loop')
 const _deleted = snapshot.val().deleted;
 const _email = snapshot.val().email;
 const _flash = snapshot.val().flash;
 const _id = snapshot.val().id;
 const _isGreaterThan = snapshot.val().isGreaterThan;
 const _price = snapshot.val().price;
 const _priceString = snapshot.val().priceString;
 const _push = snapshot.val().push;
 const _sms = snapshot.val().sms;
 const _ticker = snapshot.val().ticker;
 const _triggered = snapshot.val().triggered;
 const _urgent = snapshot.val().urgent;
 const _username = snapshot.val().username;
 const _data2 = ""
 
 admin.database().ref(`/alerts/${alertID}`).set({
 
 data1: Date.now(),
 data2: _data2,
 data3: _data2,
 data4: _data2,
 data5: _data2,
 deleted: _deleted,
 email: _email,
 flash: _flash,
 id: _id,
 isGreaterThan: _isGreaterThan,
 price: _price,
 priceString: _priceString,
 push: _push,
 sms: _sms,
 ticker: _ticker,
 triggered: _triggered,
 urgent: _urgent,
 username: _username
 });
 });
 }
 
 });
 
 });
 });
 

*/