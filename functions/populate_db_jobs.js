const admin = require(`firebase-admin`);

const serviceAccount = require(`./service_account_key.json`);

admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

const firestore = admin.firestore();

async function populateJobs() {
    const generateJobs = (total) => {
        const jobs = [];

        for (let i = 1; i < total; i++) {
            var company = Math.floor(Math.random() * (100 - 1) + 1);

            jobs.push({ id: `${i}`, company: `Empresa ${company}`, position: `Tester`, schedule: `Seg-Sex 12:00-18:00` });

        }

        return jobs;
    }

    const jobs = generateJobs(200);

    for (const job of jobs) {
        try {
            await firestore.collection('jobs').doc(job.id).set({ id: job.id, company: job.company, position: job.position, schedule: job.schedule, createOn: new Date(), });

            console.log(`Vaga ${job.position} na empresa ${job.company} criada.`);
        } catch (error) {
            console.error(`Erro ao criar empresa: `, error.message);
        }
    }
}

populateJobs();