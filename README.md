# RideLink – Backend Microservices Platform

**Module:** IT3130 – Application Development  
**Assessment:** Group Assignment · 30%  
**Project:** RideLink – Backend Microservices for a Ride-Sharing Platform  

---

## 1. System Architecture & Microservice Ownership

RideLink is a backend microservice platform decomposed into four independently executable Spring Boot services, each owning its dedicated persistence boundary:

| # | Microservice | Primary Owner | Port | Persistence / Database | Swagger UI Documentation |
|---|---|---|---|---|---|
| **1** | **Account Service** | Member 1 | `8081` | H2 File-Based (`./data/account-db`) | [http://localhost:8081/swagger-ui/index.html](http://localhost:8081/swagger-ui/index.html) |
| **2** | **Driver & Vehicle Service** | Member 2 | `8082` | H2 File-Based (`./data/driver-db`) | [http://localhost:8082/swagger-ui/index.html](http://localhost:8082/swagger-ui/index.html) |
| **3** | **Ride Management Service** | Member 3 | `8083` | H2 File-Based (`./data/ride-db`) | [http://localhost:8083/swagger-ui/index.html](http://localhost:8083/swagger-ui/index.html) |
| **4** | **Fare & Payment Service** | Member 4 | `8084` | MongoDB (`localhost:27017/fare_payment_db`) | [http://localhost:8084/swagger-ui/index.html](http://localhost:8084/swagger-ui/index.html) |

---

## 2. Interactive Swagger UI & OpenAPI Links

With the microservices running on your laptop, access each service's interactive Swagger UI:

- **Account Service (8081):** [http://localhost:8081/swagger-ui/index.html](http://localhost:8081/swagger-ui/index.html)  
  *OpenAPI JSON:* [http://localhost:8081/v3/api-docs](http://localhost:8081/v3/api-docs)
- **Driver & Vehicle Service (8082):** [http://localhost:8082/swagger-ui/index.html](http://localhost:8082/swagger-ui/index.html)  
  *OpenAPI JSON:* [http://localhost:8082/v3/api-docs](http://localhost:8082/v3/api-docs)
- **Ride Management Service (8083):** [http://localhost:8083/swagger-ui/index.html](http://localhost:8083/swagger-ui/index.html)  
  *OpenAPI JSON:* [http://localhost:8083/v3/api-docs](http://localhost:8083/v3/api-docs)
- **Fare & Payment Service (8084):** [http://localhost:8084/swagger-ui/index.html](http://localhost:8084/swagger-ui/index.html)  
  *OpenAPI JSON:* [http://localhost:8084/v3/api-docs](http://localhost:8084/v3/api-docs)

---

## 3. Quick Start & Management Scripts

Root-level utility scripts are provided to start and stop all 4 services at once:

### To Start All Services:
- **Option 1 (Double click):** Double-click `start-all.bat` in Windows File Explorer.
- **Option 2 (PowerShell):** Run:
  ```powershell
  .\start-all.ps1
  ```

### To Stop All Services:
- **Option 1 (Double click):** Double-click `stop-all.bat` in Windows File Explorer.
- **Option 2 (PowerShell):** Run:
  ```powershell
  .\stop-all.ps1
  ```

---

## 4. Building and Running Services Manually

Each service includes the Maven wrapper (`mvnw.cmd`).

### 1. Build and Run Tests
```powershell
# Account Service
cd d:\RIDELINK\account-service\account-service\account-service
.\mvnw.cmd test

# Driver & Vehicle Service
cd d:\RIDELINK\driver-vehicle-service\driver-vehicle-service\driver-vehicle-service
.\mvnw.cmd test

# Ride Management Service
cd d:\RIDELINK\ride-service\ride-service\ride-service
.\mvnw.cmd test

# Fare & Payment Service
cd d:\RIDELINK\fare-payment-service\fare-payment-service
.\mvnw.cmd test
```

### 2. Package JARs
```powershell
.\mvnw.cmd package -DskipTests
```

### 3. Run JAR Directly
```powershell
java -jar target\<service-name>-0.0.1-SNAPSHOT.jar
```

---

## 5. Security & Authentication Flow

- **Authentication Protocol:** JWT (HMAC-SHA256) issued by **Account Service** on login (`/api/auth/login`).
- **Authorization:** Role-Based Access Control (`ROLE_PASSENGER`, `ROLE_DRIVER`, `ROLE_ADMIN`).
- **Internal Service Key:** Interservice communication between Ride Service (8083) and Driver Service (8082) uses HTTP header:
  `X-Internal-Service-Key: ridelink-internal-secret-key-2026`

---

## 6. End-to-End Workflow Demonstration

1. **Register & Login (Port 8081):**
   - Register passenger at `POST /api/auth/register/passenger`
   - Register driver at `POST /api/auth/register/driver`
   - Authenticate at `POST /api/auth/login` to receive JWT token.
2. **Driver Availability & Vehicle (Port 8082):**
   - Create profile at `POST /api/drivers/profile`
   - Add vehicle at `POST /api/drivers/me/vehicles`
   - Set status to `AVAILABLE` at `PATCH /api/drivers/me/availability`
   - Set current GPS coordinates at `PATCH /api/drivers/me/location`
3. **Fare Quote (Port 8084):**
   - Request indicative estimate at `POST /api/fares/estimate` with pickup, destination, distance, and duration.
4. **Ride Lifecycle (Port 8083):**
   - Passenger creates ride: `POST /api/rides` (`REQUESTED`)
   - Driver assignment: `POST /api/rides/{rideId}/assign` (`ASSIGNED`)
   - Driver accepts: `POST /api/rides/{rideId}/accept` (`ACCEPTED`)
   - Driver starts ride: `POST /api/rides/{rideId}/start` (`IN_PROGRESS`)
   - Driver completes ride: `POST /api/rides/{rideId}/complete` (`COMPLETED`)
5. **Payment & Receipt (Port 8084):**
   - Process payment: `POST /api/payments` with `Idempotency-Key` header
   - Retrieve digital receipt: `GET /api/receipts/{receiptId}`
