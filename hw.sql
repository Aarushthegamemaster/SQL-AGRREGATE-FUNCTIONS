-- ================================
-- Marine Life Observer Database
-- ================================

-- Drop tables if they already exist (for reruns)
DROP TABLE IF EXISTS observations;
DROP TABLE IF EXISTS species;
DROP TABLE IF EXISTS observers;

-- ================================
-- Table: observers
-- ================================
CREATE TABLE observers (
    observer_id SERIAL PRIMARY KEY,       -- Unique ID for each observer
    name VARCHAR(100) NOT NULL,           -- Observer's name
    organization VARCHAR(100),            -- Organization affiliation
    contact_email VARCHAR(100) UNIQUE     -- Email for contact
);

-- ================================
-- Table: species
-- ================================
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,        -- Unique ID for each species
    common_name VARCHAR(100) NOT NULL,    -- Common name (e.g., Clownfish)
    scientific_name VARCHAR(150),         -- Scientific name
    animal_group VARCHAR(50) NOT NULL,    -- Group (Fish, Mammal, etc.)
    habitat VARCHAR(100)                  -- Habitat type (Coral Reef, Deep Sea, etc.)
);

-- ================================
-- Table: observations
-- ================================
CREATE TABLE observations (
    observation_id SERIAL PRIMARY KEY,    -- Unique ID for each observation
    observer_id INT NOT NULL,             -- FK to observers
    species_id INT NOT NULL,              -- FK to species
    observation_date DATE NOT NULL,       -- Date of observation
    location VARCHAR(100) NOT NULL,       -- Location name
    length_meters DECIMAL(5,2),           -- Length in meters
    weight_kg DECIMAL(6,2),               -- Weight in kilograms
    notes TEXT,                           -- Additional notes
    FOREIGN KEY (observer_id) REFERENCES observers(observer_id)
        ON DELETE CASCADE,
    FOREIGN KEY (species_id) REFERENCES species(species_id)
        ON DELETE CASCADE
);

-- ================================
-- Sample Data
-- ================================

-- Observers
INSERT INTO observers (name, organization, contact_email)
VALUES
('Alice Marine', 'Ocean Watch', 'alice@oceanwatch.org'),
('Bob Diver', 'Sea Explorers', 'bob@seaexplorers.com');

-- Species
INSERT INTO species (common_name, scientific_name, animal_group, habitat)
VALUES
('Clownfish', 'Amphiprioninae', 'Fish', 'Coral Reef'),
('Blue Whale', 'Balaenoptera musculus', 'Mammal', 'Open Ocean'),
('Octopus', 'Octopoda', 'Cephalopod', 'Coastal Waters');

-- Observations
INSERT INTO observations (observer_id, species_id, observation_date, location, length_meters, weight_kg, notes)
VALUES
(1, 1, '2026-11-20', 'Great Barrier Reef', 0.12, 0.25, 'Observed near anemone'),
(1, 3, '2026-11-21', 'Monterey Bay', 1.50, 15.00, 'Camouflaged against rocks'),
(2, 2, '2026-11-19', 'Pacific Ocean', 25.00, 150000.00, 'Migrating north');

-- ================================
-- Useful Queries
-- ================================

-- 1. List all observations with species and observer details
SELECT o.observation_id, s.common_name, s.animal_group, ob.name AS observer_name,
       o.observation_date, o.location, o.length_meters, o.weight_kg, o.notes
FROM observations o
JOIN species s ON o.species_id = s.species_id
JOIN observers ob ON o.observer_id = ob.observer_id
ORDER BY o.observation_date DESC;

-- 2. Count total observations per species
SELECT s.common_name, COUNT(o.observation_id) AS total_observations
FROM species s
LEFT JOIN observations o ON s.species_id = o.species_id
GROUP BY s.common_name
ORDER BY total_observations DESC;

-- 3. Filter observations by habitat
SELECT s.common_name, s.habitat, o.location, o.observation_date
FROM observations o
JOIN species s ON o.species_id = s.species_id
WHERE s.habitat = 'Coral Reef';

-- 4. Find largest animal observed by weight
SELECT s.common_name, o.weight_kg, o.location
FROM observations o
JOIN species s ON o.species_id = s.species_id
ORDER BY o.weight_kg DESC
LIMIT 1;
