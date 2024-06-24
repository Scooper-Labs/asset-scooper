# **Asset Scooper** Doc

**Efficiently manage and swap your low-value tokens with a single scan.**

## Introduction

**Asset Scooper** is an innovative solution that allows users to scan, aggregate, and swap their low-value tokens in a single transaction, returning ETH or their choiced destination token. Utilizing the 1inch swap API, this application simplifies token management, helping users maximize the utility of their crypto assets.

## Team Information

- **Paul Elisha**: Smart Contract Developer, Documentarian
- **Flora Osutayi**: UI/UX Designer
- **Blessing Samuel**: Frontend Developer, Project Manager
- **Ibrahim Sunday Ijai**: Frontend Developer

### Live Demo

[https://demo.token-aggregator.app](#)

### Slides

[https://www.figma.com/design/KBCPUSwdncf5FJNNUhAuF6/Asset-scooper?node-id=2001-13994&t=2caK4E4ll3uP2bNP-0]

## Table of Contents

1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Technical Details](#technical-details)
4. [Setup and Deployment](#setup-and-deployment)
5. [Demo](#demo)
6. [Contributing](#contributing)
7. [License](#license)
8. [Acknowledgements](#acknowledgements)
9. [Future Work](#future-work)
10. [FAQs](#faqs)
11. [Conclusion](#conclusion)

## Project Overview

### Problem Statement

Managing multiple low-value tokens can be cumbersome and inefficient, often leading to unused assets. There is a need for a streamlined method to aggregate and swap these tokens efficiently.

### Solution

Asset Scooper provides a user-friendly platform that scans, aggregates, and swaps low-value tokens for ETH or their choiced valuable token, in a single transaction. This solution leverages the 1inch swap API to optimize token management and maximize user benefits.

### Impact

Asset Scooper enhances user experience by simplifying token management, reducing transaction fees, and ensuring optimal token utilization. This solution empowers users to manage their assets more effectively, contributing to a more efficient and user-friendly DeFi ecosystem.

## Market Opportunity

- **User-Friendly Token Management**: Asset Scooper offers a seamless interface for managing and swapping low-value tokens, addressing a common pain point in the crypto space.
- **Cost Efficiency**: By aggregating multiple low-value tokens into a single transaction, users save on transaction fees, making their crypto management more cost-effective.
- **Increased Adoption**: Offering a seamless and efficient solution can attract more users to the platform, increasing overall adoption and engagement.
- **Financial Optimization**: By converting low-value tokens into ETH, users can better utilize their assets and potentially increase their portfolio value.

## Features

- **Token Scanning**: Automatically scan and identify low-value tokens in a user's wallet.
- **Aggregation**: Aggregate low-value tokens into a single, higher-value asset.
- **One-Click Swap**: Swap aggregated tokens in a single transaction using the 1inch swap API.
- **User-Friendly Interface**: Intuitive and easy-to-use interface for seamless token management.

## Technical Details

### Architecture

Asset Scooper uses a microservices architecture with a web frontend and a backend.

- **Frontend**: Built with React for a responsive user experience.
- **Backend**: Node.js for efficient data handling and API integration.
- **Smart Contract**: Solidity for secure and transparent token aggregation and swapping.
- **Integration**: 1inch API, Smart Wallet, 

### Tech Stack

- **Frontend**: React
- **Backend**: Node.js, Express
- **Smart Contracts**: Solidity
- **API Integration**: 1inch swap API

## Setup and Deployment

### Prerequisites

- Node.js
- Truffle or Hardhat
- Metamask Wallet

### Installation

1. **Clone the repository**:
git clone https://github.com/your-repo/token-aggregator.git

2. **Install dependencies**:
cd token-aggregator
npm install

3. **Deploy Smart Contracts**:
truffle migrate --network <network-name>

4. **Run the application**:
npm start

## Demo

### Walkthrough

1. **Access the Asset Scooper Application**
- Open your preferred web browser.
- Navigate to the Token Aggregator web application by entering the URL: [https://token-aggregator.app](#).

2. **Connect Wallet**
- Connect your Metamask wallet to the application.
- Or create a smart wallet.

3. **Automatically Scan Tokens**
- Automatically scan tokens and identify low-value tokens in your wallet.
- Review the list of tokens detected in your wallet.

4. **Aggregate Tokens**
- View the list of identified low-value tokens.
- Click "Sweep" to combine them into a single, higher-value asset.

5. **Swap Tokens**
- Enter the minimum output amount.
- Click "Swap" to initiate the swap using the 1inch swap API.

6. **Transaction Confirmation**
- Confirm the transaction in your Metamask wallet.
- View the transaction status and details on the application.

7. **Receive ETH**
- Upon successful completion of the swap, you will receive ETH in your wallet.
- Check your wallet balance to verify the transaction.

## Future Work

- **Enhanced Analytics**: Implementing detailed analytics for users to track their token swaps and performance.
- **Support for More Tokens**: Expanding the range of supported tokens for aggregation and swapping.
- **Multi-Chain Support**: Expanding support to include multiple blockchain networks.
- **Mobile App**: Developing a mobile application for on-the-go token management.

## FAQs

### Common Questions and Issues

1. **How does Asset Scooper work?**
Asset Scooper scans, aggregates, and swaps low-value tokens in a single transaction using the 1inch swap API.

2. **Which tokens are supported?**
Asset Scooper supports all ERC-20 tokens.

3. **How can I add my token to Asset Scooper?**
Contact us at support@asset-scooper.app to register your token.

## Acknowledgements

1. **Team Members**: For your dedication, hard work, and collaborative spirit. Each member's unique skills and commitment have been key to our success.
2. **Hackathon Organizers**: For providing an incredible platform that fosters innovation, creativity, and collaboration.
3. **Open Source Community**: For the valuable resources and tools that helped in the development of TokenAggregator.
4. **1inch Team**: For providing an excellent API and support that made this project possible.

## Conclusion

Asset Scooper represents a significant advancement in the management and utilization of low-value tokens. By providing a streamlined, user-friendly solution for scanning, aggregating, and swapping tokens, Asset Scooper empowers users to maximize the utility of their assets. This innovative approach not only enhances user experience but also contributes to the broader efficiency and adoption of DeFi solutions.
