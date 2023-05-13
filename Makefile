compile: 
	npx hardhat compile

chain:	
	npx hardhat node

deploy:
	npx hardhat run scripts/deploy.ts --network localhost

deploy-zhejiang:
	npx hardhat run scripts/deploy.ts --network zhejiang