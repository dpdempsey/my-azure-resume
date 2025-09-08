# ☁️ my-azure-resume

Welcome to my take on the [Cloud Resume Challenge](https://cloudresumechallenge.dev/) — built with Microsoft Azure! 🚀

Inspired by [A Cloud Guru's video](https://www.youtube.com/watch?v=ieYrBWmkfno&t=3912s), I added my own twists and enhancements. This project was a fantastic way to level up my Azure and web development skills while studying for the AZ-204 exam. Feel free to fork this repo and create your own cloud-powered resume! 💡


## 🏗️ Architecture
![Architecture Diagram](/assets/my-azure-resume.drawio.png)


## ⚙️ Infrastructure
**Main Azure services:**
- 🌐 Static Web Apps
- 🪐 Cosmos DB
- ⚡ Azure Functions

All infrastructure is deployed using Bicep (Azure's IaC language), reflecting the practices I use in my role at Deloitte Australia. Check out the [`infra`](./infra) folder for details! 🛠️


## 🎨 Frontend
The site is based on the [CeeVee template](https://styleshout.com/free-templates/ceevee/) (credit: [styleshout.com](https://styleshout.com)), with lots of customizations and clean-up. 

Deployment is fully automated via the `website.pipeline.yaml` CI/CD pipeline. Any changes merged to `main` in the `frontend/` folder are instantly published! 

This approach allows me to completely re-do the website, possisbly using something different like React, and have it be easily deployed and hosted on Azure! ✨


## 🖥️ Backend
The visitor counter is powered by an Azure Function that reads and updates a document in Cosmos DB. All build and deployment steps for the function app are managed by pipelines in [`infra/pipelines`](./infra/pipelines). 🔄


## 🤖 GitHub Copilot Agent Mode
Much of this project was built using GitHub Copilot's agent mode for rapid code generation, automation, and troubleshooting. It made the process faster and more efficient.


## 🚧 Future Enhancements
- [ ] Add more API (Google Bookshelf reading list)
- [ ] Re-do website in react or AngularJS
- [ ] Create a resume chatbot using an LLM and agent design patterns

---

Thanks for checking out my project! If you have feedback or want to connect, feel free to reach out. 😊