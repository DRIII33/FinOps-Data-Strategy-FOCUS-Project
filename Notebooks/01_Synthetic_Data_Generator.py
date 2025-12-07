# FILE: 01_Synthetic_Data_Generator.ipynb
# DESCRIPTION: Generates synthetic multi-cloud billing data and business metrics (DAU)
#              with a simulated data quality issue (40% unallocated cost).

import pandas as pd
import numpy as np
from datetime import date, timedelta
import random

# --- 1. CONFIGURATION ---
# Date Range (6 months up to Dec 2025)
END_DATE = date(2025, 12, 5)
START_DATE = END_DATE - timedelta(days=180)
date_range = [START_DATE + timedelta(days=x) for x in range((END_DATE - START_DATE).days + 1)]

# Core Dimensions
CLOUD_PROVIDERS = ['AWS', 'GCP']
SERVICES = {
    'AWS': ['EC2', 'S3', 'RDS', 'SageMaker', 'Lambda', 'Networking'],
    'GCP': ['Compute Engine', 'Cloud Storage', 'Cloud SQL', 'Vertex AI', 'Cloud Functions', 'Networking']
}
PRODUCT_NAMES = ['Aether', 'Nexus', 'Internal-Tools']
ENVIRONMENTS = ['Production', 'Staging', 'Dev']
TEAM_OWNERS = ['Product-Aether', 'Product-Nexus', 'Platform-Ops', 'Data-Science']

# --- 2. SYNTHETIC DATA GENERATOR: RAW BILLING DATA ---
data = []
for day in date_range:
    # Scale total daily spend (simulate growth and spikes)
    base_daily_cost = 5000 + (day - START_DATE).days * 10
    spike_factor = 1.5 if day.month == 10 and day.day in [15, 16] else 1
    num_records = random.randint(200, 300)

    for _ in range(num_records):
        provider = random.choice(CLOUD_PROVIDERS)
        service = random.choice(SERVICES[provider])
        # Log-normal distribution for cost
        cost = np.random.lognormal(mean=np.log(base_daily_cost / num_records), sigma=0.6) * spike_factor
        usage = cost * random.uniform(5, 20)
        usage_unit = 'Hours' if 'Compute' in service or 'EC2' in service else 'GB' if 'Storage' in service or 'S3' in service else 'Operations'

        # Initialize to None/default for potential unallocated records
        product = None
        environment = None
        team = None
        is_unallocated_flag = False

        # Allocation Logic: 40% chance of being unallocated (missing critical tags)
        if random.random() < 0.40:
            is_unallocated_flag = True
        else:
            product = random.choice(PRODUCT_NAMES)
            # Bias costs towards 'Aether' Production (for Unit Economics)
            if product == 'Aether' and random.random() < 0.7:
                 environment = 'Production'
                 team = 'Product-Aether'
                 cost *= 1.5
            else:
                 environment = random.choice(ENVIRONMENTS)
                 team = random.choice(TEAM_OWNERS)

        # Commitment/Amortization Logic
        is_commitment = random.random() < 0.15
        amortized_cost = cost * random.uniform(0.7, 0.9) if is_commitment else cost

        data.append({
            'line_item_id': f'L{day.strftime("%Y%m%d")}_{random.randint(10000, 99999)}',
            'billing_period': day.strftime('%Y-%m'),
            'billing_date': day,
            'cloud_provider': provider,
            'service_name': service,
            'tag_product': product,
            'tag_environment': environment,
            'tag_team': team,
            'usage_amount': round(usage, 3),
            'usage_unit': usage_unit,
            'cost_in_usd': round(cost, 2),
            'amortized_cost_in_usd': round(amortized_cost, 2),
            'is_commitment': is_commitment,
            'is_unallocated': is_unallocated_flag,
            'region': random.choice(['us-east-1', 'us-west-2', 'europe-west1', 'asia-east2']),
        })

df_raw_billing = pd.DataFrame(data)

# --- 3. SYNTHETIC DATA GENERATOR: BUSINESS METRICS (DAU) ---
dau_data = []
for day in date_range:
    # Simulate steady growth for Product Aether
    base_dau = 50000 + (day - START_DATE).days * 50
    if day.month == 11 and day.day > 10:
        base_dau *= 1.15 # Marketing spike in Nov
    dau = int(base_dau * random.uniform(0.95, 1.05))

    dau_data.append({
        'business_date': day,
        'product_name': 'Aether',
        'daily_active_users': dau,
    })

df_dau = pd.DataFrame(dau_data)

# --- 4. EXPORT & VALIDATION ---
df_raw_billing['billing_date'] = df_raw_billing['billing_date'].astype(str)
df_dau['business_date'] = df_dau['business_date'].astype(str)

RAW_BILLING_FILE = "raw_multi_cloud_billing_data.csv"
DAU_FILE = "business_dau_metrics.csv"
DATA_DICT_FILE = "data_dictionary.csv"

# Export the files
df_raw_billing.to_csv(RAW_BILLING_FILE, index=False)
df_dau.to_csv(DAU_FILE, index=False)

# Validation check
total_cost = df_raw_billing['amortized_cost_in_usd'].sum()
unallocated_cost = df_raw_billing[df_raw_billing['is_unallocated']]['amortized_cost_in_usd'].sum()
allocation_rate = (total_cost - unallocated_cost) / total_cost * 100

print(f"File '{RAW_BILLING_FILE}' created. Total Cost: ${total_cost:,.2f}")
print(f"File '{DAU_FILE}' created.")
print(f"Initial Allocation Rate: {allocation_rate:.2f}% (The problem to solve!)")
