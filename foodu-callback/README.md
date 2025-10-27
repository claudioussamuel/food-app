# FooduApp Payment Callback Page

This is the callback page for Paystack payment redirects in FooduApp.

## 🚀 Quick Setup

### Option 1: GitHub Pages (Recommended)

1. **Create GitHub Repository**
   ```bash
   # Create a new repository named 'foodu-callback' or 'foodu-web'
   ```

2. **Upload Files**
   - Upload `index.html` to the repository root
   - Commit the changes

3. **Enable GitHub Pages**
   - Go to repository Settings
   - Navigate to "Pages"
   - Source: Deploy from branch
   - Branch: `main` or `master`
   - Folder: `/ (root)`
   - Click "Save"

4. **Get Your URL**
   - Your callback URL will be: `https://YOUR_USERNAME.github.io/foodu-callback/`
   - Or if repo is named `foodu-web`: `https://YOUR_USERNAME.github.io/foodu-web/`

5. **Update FooduApp**
   - Open `lib/services/paystack_payment_service.dart`
   - Change line 35:
     ```dart
     'callback_url': callbackUrl ?? 'https://YOUR_USERNAME.github.io/foodu-callback/',
     ```
   - Open `lib/screens/payment/paystack_webview_screen.dart`
   - Update the URL detection (around line 95 and 171):
     ```dart
     if (currentUrl.contains('YOUR_USERNAME.github.io/foodu-callback'))
     // and
     if (request.url.startsWith('https://YOUR_USERNAME.github.io/foodu-callback'))
     ```

### Option 2: Use Existing ghig-web (No Setup)

Your app is already configured to use `https://ghig-web.github.io`. This works immediately without any changes.

**Current configuration**:
- ✅ Callback URL: `https://ghig-web.github.io`
- ✅ Detection: Already implemented
- ✅ Status: Working

## 📋 What This Page Does

1. **Receives Redirect**: Paystack redirects here after payment
2. **Shows Success**: Displays a beautiful success animation
3. **Provides Feedback**: Shows processing message
4. **Enables Detection**: App detects this URL and closes payment screen
5. **Logs Details**: Console logs payment reference for debugging

## 🎨 Features

- ✅ Beautiful gradient background
- ✅ Smooth animations
- ✅ Success checkmark
- ✅ Loading spinner
- ✅ Floating particles effect
- ✅ Responsive design
- ✅ Mobile-friendly
- ✅ Professional appearance

## 🔧 Customization

### Change Colors

Edit the CSS in `index.html`:

```css
/* Change gradient */
background: linear-gradient(135deg, #YOUR_COLOR1 0%, #YOUR_COLOR2 100%);

/* Change success color */
color: #YOUR_SUCCESS_COLOR;
```

### Change Text

Edit the HTML:

```html
<h1>Your Custom Title</h1>
<p class="subtitle">Your custom message</p>
```

### Add Logo

Add your logo:

```html
<img src="your-logo.png" alt="FooduApp" style="width: 100px; margin-bottom: 20px;">
```

## 🧪 Testing

### Test Locally

1. Open `index.html` in a browser
2. Add query parameters:
   ```
   file:///path/to/index.html?reference=TEST_REF_123&status=success
   ```
3. Check console for logs

### Test with Paystack

1. Deploy to GitHub Pages
2. Update your app with the new URL
3. Make a test payment
4. Verify redirect works

## 📱 How It Works in the App

### Mobile (WebView)
```
Payment → Paystack → Redirect to callback → WebView detects URL → Auto-close
```

### Web (Iframe)
```
Payment → Paystack → Redirect to callback → Window URL changes → Auto-detect → Close
```

## 🔐 Security

- ✅ No sensitive data stored
- ✅ Client-side only
- ✅ No backend required
- ✅ HTTPS enforced (GitHub Pages)
- ✅ Payment verification done by app

## 📊 URL Parameters

The callback URL receives these parameters from Paystack:

- `reference` or `trxref`: Payment reference
- `status`: Payment status (success/failed)

Example:
```
https://YOUR_USERNAME.github.io/foodu-callback/?reference=FOODU_123456&status=success
```

## 🐛 Troubleshooting

### Callback not working?

1. **Check URL**: Ensure GitHub Pages URL is correct
2. **Check Detection**: Verify URL detection in app matches callback URL
3. **Check HTTPS**: GitHub Pages uses HTTPS automatically
4. **Check Console**: Look for logs in browser console

### Page not loading?

1. **Wait**: GitHub Pages can take a few minutes to deploy
2. **Check Settings**: Ensure Pages is enabled in repository settings
3. **Check Branch**: Ensure correct branch is selected
4. **Clear Cache**: Try clearing browser cache

## 📝 Notes

- This page is **only for redirects**, not for actual payment processing
- Payment verification happens in the app via Paystack API
- The page can be customized to match your brand
- Works on all devices and browsers

## 🎯 Current Status

**Option 1**: Using `ghig-web.github.io` (Current) ✅
- No setup needed
- Works immediately
- Shared with ghig-app

**Option 2**: Using your own callback (Recommended for production) 🚀
- Professional branding
- Full control
- Requires GitHub Pages setup

---

**Need help?** Check the main documentation: `PAYSTACK_CALLBACK_SETUP.md`
