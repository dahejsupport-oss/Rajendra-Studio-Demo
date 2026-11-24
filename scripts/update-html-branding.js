const fs = require('fs');
const path = require('path');

const htmlFiles = [
  'about.html',
  'admin-login.html',
  'admin.html',
  'categories.html',
  'checkout.html',
  'contact.html',
  'index.html',
  'orders.html',
  'product-detail.html',
  'products.html',
  'track-order.html'
];

htmlFiles.forEach(file => {
  [file, path.join('public', file)].forEach(filePath => {
    if (!fs.existsSync(filePath)) return;
    let content = fs.readFileSync(filePath, 'utf8');

    content = content.replace(/alt="Dahej Support"/g, 'alt="Dahej Support"');
    content = content.replace(/alt="Dahej Support"/g, 'alt="Dahej Support"');
    content = content.replace(/title="Back to Dahej Support Website"/g, 'title="Back to Dahej Support Website"');
    content = content.replace(/title="Back to Dahej Support Website"/g, 'title="Back to Dahej Support Website"');

    // Admin branding
    content = content.replace(
      /<span class="sidebar-brand-name">RAJENDRA<span style="color: #C6934B;">STUDIO<\/span><\/span>/g,
      '<span class="sidebar-brand-name">DAHEJ<span style="color: #EA6A00;">SUPPORT</span></span>'
    );
    content = content.replace(
      /<span class="sidebar-brand-sub">Studio OS • Executive<\/span>/g,
      '<span class="sidebar-brand-sub">Management Portal</span>'
    );

    fs.writeFileSync(filePath, content, 'utf8');
  });
});

console.log('HTML branding successfully updated to Dahej Support across all pages.');
