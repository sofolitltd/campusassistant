// Required by firebase_messaging's web implementation — it auto-registers
// this exact file at the origin root to handle push while the tab isn't
// focused. Config values here are the same public client config already
// committed in lib/firebase_options.dart (Firebase web config is not a
// secret — it identifies the project, it doesn't authenticate against it).
importScripts('https://www.gstatic.com/firebasejs/10.14.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.14.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyAFZWMRz0_1GxHAS2NNQ6QvnsTDbuB98RY',
  appId: '1:819902547125:web:58aac406ac797f28c1eafc',
  messagingSenderId: '819902547125',
  projectId: 'campusassistantbd',
  authDomain: 'campusassistantbd.firebaseapp.com',
  storageBucket: 'campusassistantbd.appspot.com',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const notification = payload.notification || {};
  self.registration.showNotification(notification.title || 'Campus Assistant', {
    body: notification.body || '',
    icon: '/icons/Icon-192.png',
    data: payload.data,
  });
});
