const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendMessageNotification = functions.firestore
    .document("messages/{messageId}")
    .onCreate(async (snapshot, context) => {
        const message = snapshot.data();
        const recipientId = message.recipientId; // Mesajın alıcısının ID'sini alıyoruz.

        try {
            // Alıcıyı Firestore'dan alıyoruz
            const userDoc = await admin.firestore().collection("users").doc(recipientId).get();

            if (!userDoc.exists) {
                console.log("No such user with ID:", recipientId);
                return null; // Alıcı bulunamadıysa, fonksiyon sonlanır.
            }

            // Alıcının FCM token'ını alıyoruz
            const recipientToken = userDoc.data().fcm_token;

            if (!recipientToken) {
                console.log("No FCM token for user:", recipientId);
                return null; // Token yoksa işlem yapılmaz.
            }

            // Bildirim payload'ı oluşturuyoruz
            const payload = {
                notification: {
                    title: message.senderName || "Yeni Mesaj", // Gönderenin ismi ya da varsayılan başlık
                    body: message.content || "Mesaj içeriği yok", // Mesaj içeriği ya da varsayılan içerik
                    clickAction: "FLUTTER_NOTIFICATION_CLICK", // Uygulama açıldığında yapılacak işlem
                },
                data: {
                    messageId: context.params.messageId, // Mesaj ID'sini data olarak da gönderiyoruz
                    recipientId: recipientId, // Alıcının ID'sini de ekliyoruz
                }
            };

            // Firebase Cloud Messaging ile bildirim gönderiyoruz
            await admin.messaging().sendToDevice(recipientToken, payload);
            console.log("Notification sent successfully to:", recipientId);
            return null; // Fonksiyon başarıyla tamamlandı.

        } catch (error) {
            console.error("Error sending notification:", error);
            return null; // Hata durumunda işlem sonlanır.
        }
    });
