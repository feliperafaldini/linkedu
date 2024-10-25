const admin = require(`firebase-admin`);

const serviceAccount = require(`./service_account_key.json`);

admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

const firestore = admin.firestore();

async function populateCompanies() {
    const generateCompanies = (total) => {
        const companies = [];

        for (let i = 1; i <= total; i++) {
            companies.push({ id: `${i}`, name: `Empresa ${i}`, address: `Rua ${i}`, city: `Sorocaba`, state: `SP`, imgPath: null });
        }

        return companies;
    };

    const companies = generateCompanies(100);

    for (const company of companies) {
        try {
            await firestore.collection(`companies`).doc(company.id).set({
                uid: company.id,
                name: company.name,
                address: company.address,
                city: company.city,
                state: company.state,
                imagePath: company.imgPath,
                createOn: new Date(),
            });

            console.log(`Empresa ${company.name} criada.`);

        } catch (error) {
            console.error(`Erro ao criar empresa: `, error.message);
        }
    }
}

populateCompanies();