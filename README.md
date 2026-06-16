# ☁️ my-azure-resume

Welcome to my take on the [Cloud Resume Challenge](https://cloudresumechallenge.dev/) — built with Azure.

This project was inspired by [A Cloud Guru's video](https://www.youtube.com/watch?v=ieYrBWmkfno&t=3912s) and was a great way to showcase my Azure, DevOps and development skills.


## 🏗️ Architecture
![Architecture Diagram](/assets/my-azure-resume.drawio.png)


## ⚙️ Infrastructure
**Main Azure services:**
- 🌐 Static Web Apps
- 🪐 Cosmos DB
- ⚡ Azure Functions

All infrastructure is deployed using Bicep. Check out the [`infra`](./infra) folder for details


## 🎨 Frontend
The site is based on the [CeeVee template](https://styleshout.com/free-templates/ceevee/) (credit: [styleshout.com](https://styleshout.com)), albeit a much trimmed down version.  

Deployment is fully automated via the `website.pipeline.yaml` CI/CD pipeline. Any changes merged to `main` in the `frontend/` folder are deployed automatically.

This approach allows me to completely re-do the website, possisbly even using a different framework or stack, and have it be easily re-deployed and available for people to visit. 


## 🖥️ Backend
The visitor counter is powered by an Azure Function that reads and updates a document in Cosmos DB. All build and deployment steps for the function app are managed by pipelines in [`infra/pipelines`](./infra/pipelines). Once again, deployment for the backend is automated by these pipelines.

-----

Thanks for visiting!