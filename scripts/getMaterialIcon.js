const https = require("https");
var myArgs = process.argv.slice(2);

if(myArgs.length === 0) {
    console.log('require icon id');
    return;
}

const id = `ic_${myArgs[0]}_black_24px.svg`;

https.get(`https://storage.googleapis.com/material-icons/external-assets/v2/icons/svg/${id}`, response => {
    let body = '';
    response.on('data', c => body += c);
    response.on('end', () => {
        body = body.replace('height="24" ', '');
        body = body.replace('width="24" ', '');
        body = body.replace('fill="#000000" ', '');
        body = body.replace('<svg ', '<svg fill="currentColor" ')
        body = body.replace(/\s*<path[^\/]*fill="none"\/>/, '');
        console.log(body);
    });
});
