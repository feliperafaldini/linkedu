(async () => {
    const admin = require('firebase-admin');
    var serviceAccount = require('./service_account_key.json');

    admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

    const firestore = admin.firestore();


    try {
        const startTime = Date.now();

        const collections = await firestore.listCollections();

        for (const collection of collections) {
            const snapshot = await collection.get();
            const docs = snapshot.docs;

            docs.forEach(doc => {
                console.log(`Documento da coleção ${collection.name}:`, doc.data());
            });

        }

        const endTime = Date.now()

        const timeTaken = (endTime - startTime) / 1000;

        console.log(`Tempo total para coletar todos os dados do firestore ${timeTaken} segundos.`);
    } catch (error) {
        console.error('Erro ao recuperar dados do firebase: ', error);
    }

})();
