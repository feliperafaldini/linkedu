const admin = require(`firebase-admin`);

const serviceAccount = require(`./service_account_key.json`);

admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

const auth = admin.auth();
const firestore = admin.firestore();

async function populateUsers() {
    const generateUsers = (total) => {
        const users = [];

        for (let i = 1; i <= total; i++) {
            users.push({ email: `user${i}@example.com`, password: `password${i}`, name: `User`, lastName: `${i}` });
        }

        return users;
    };

    const users = generateUsers(1000);

    for (const user of users) {
        try {
            const userCredential = await auth.createUser({
                email: user.email,
                password: user.password,
                displayName: `${user.name} ${user.lastName}`,
            });

            await firestore.collection(`users`).doc(userCredential.uid).set({
                uid: userCredential.uid,
                email: user.email,
                name: `${user.name} ${user.lastName}`,
                image: null,
                createOn: new Date(),
            });

            console.log(`Usuário ${userCredential.displayName} criado.`);

        } catch (error) {
            console.error(`Erro ao criar usuário:`, error.message);
        }
    }
}

populateUsers();