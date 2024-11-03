## Inspiration

Our platform addresses the need for personalized roommate matching, especially as urbanization and rising rental costs drive shared living. Traditional methods often overlook deeper lifestyle and personality traits crucial for compatibility. Leveraging advancements in NLP and inspired by personalized design in social and dating apps, we created a solution that’s both user-friendly and highly scalable. Our platform is not limited to specific apartments or colleges, making it accessible to a wide range of users seeking meaningful and harmonious living arrangements.

## Meet The Team

As freshman CS majors at UT Austin who struggled to find compatible roommates, we created an app to make the process easier for others. Our app personalizes roommate matching based on compatibility and shared preferences in a user-friendly, centralized platform.
As a team with diverse skill sets, each member brought unique strengths to the project: Aatmodhee led the development of our AI model, crafting a solution to understand and vectorize user preferences, while Sullivan, Uthman, and Nithin collaborated on both front-end and back-end development, ensuring seamless integration, data flow, and an intuitive, engaging user interface.

## How It Works

For our project, we designed a platform that connects potential roommates based on shared interests, habits, and lifestyle preferences. Using a pre-trained transformer model, we vectorize responses to curated questions, enabling us to create personalized matches beyond typical criteria. We aim to make finding compatible roommates seamless and stress-free, fostering connections that lead to harmonious and enjoyable living arrangements.

**Tech Stack**

- Flutter
- Dart
- Supabase
- PostgreSQL
- InterSystems IRIS Vector Database
- FastAPI
- MiniLM SentenceTransformers
- PyTorch
- Front-End Design with Flutter

For the front end of our roommate-matching platform, we used Google’s FlutterSDK and its accompanying Dart programming language to build a responsive, cross-platform interface that creates an intuitive user experience on both iOS and Android mobile devices. Flutter’s powerful UI toolkit allowed us to create a visually appealing, interactive app that is both fast and easy to navigate, delivering a seamless experience to users.

Key components of the front end include:

- **Questionnaire Interface:** A smooth, guided questionnaire that prompts users with curated questions about their lifestyle, preferences, and habits.
- **User Profile:** Users can review and update their profile and questionnaire answers at any time.
- **Match Results Display:** A visually engaging page that lists potential roommate matches, showing compatibility scores and key traits.

## Intertwined AI Matching System

At the heart of our matching algorithm is a transformer model that vectorizes user questionnaire responses into high-dimensional vectors, capturing semantic meaning and context. This allows us to quantify similarities between users for more nuanced matching. We use the InterSystems database for efficient data management and storage, chosen for its scalability and flexibility. It securely stores user profiles, questionnaire responses, and vectorized embeddings, enabling seamless, real-time data retrieval. Additionally, we filter the graph to rebalance the vector embeddings of individuals who deviate from the mean, ensuring they remain integrated within the dataset.

**Vectorization Process:**

- **Text Pre-processing:** We clean and normalize responses to eliminate unnecessary formatting and noise, ensuring clear and relevant input for the model.
- **Embedding Generation:** The transformer model generates embeddings for each response, capturing contextual information beyond surface-level words.
- **Similarity Calculation:** We calculate similarity scores between user embeddings using techniques like cosine similarity to rank potential matches based on shared interests and lifestyle compatibility.
- **Match History:** We maintain a record of past matches and interactions, enabling users to revisit profiles and track their matching preferences over time.

**Ground-up Graph Convolutional Model:**

- **Anomaly Detection with Graph Networks:** In order to prevent people from being marginalized in the dataset being, we add graph convolutions to cluster data, and graph spectral filtering to find anomalies and adjust the algorithm accordingly. Our algorithm has a loss below 1%.

## Connecting the Front End to the Back End

- **API Development:** We developed RESTful APIs that handle requests from the front end, such as submitting questionnaire responses and retrieving match results.
- **Data Pipeline:** User responses from the front end are passed through an API to the transformer model for vectorization, then stored in the InterSystems database.
- **Asynchronous Matching:** After vectorization, the back end asynchronously calculates similarity scores, returning ranked matches to the front end for display on the Match Results page.

## What’s Next For roommATe

We have developed a GenAI pipeline capable of generating example roommates. Our next step is to integrate a calibration feature that utilizes these generated profiles to assess the current user’s preferences by asking targeted questions. This calibration will enhance our matching process, providing users with more accurate and personalized roommate suggestions.
