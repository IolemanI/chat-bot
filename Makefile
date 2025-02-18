.PHONY: clean train-nlu train-core cmdline server

TEST_PATH=./

help:
	@echo "    clean"
	@echo "        Remove python artifacts and build artifacts."
	@echo "    train-nlu"
	@echo "        Trains a new nlu model using the projects Rasa NLU config"
	@echo "    train-core"
	@echo "        Trains a new dialogue model using the story training data"
	@echo "    action-server"
	@echo "        Starts the server for custom action."
	@echo "    cmdline"
	@echo "       This will load the assistant in your terminal for you to chat."


clean:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f  {} +
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info
	rm -rf docs/_build

train-nlu:
	python -m rasa_nlu.train -c nlu_config.yml --data data/nlu_data.md -o models --fixed_model_name nlu --project current --verbose

train-core:
	python -m rasa_core.train -d domain.yml -s data/stories.md -o models/current/dialogue -c policies.yml

train-core-i:
	python -m rasa_core.train interactive -d domain.yml -s data/stories.md --endpoints endpoints.yml -o models/current/dialogue -c policies.yml

cmdline:
	python -m rasa_core.run -d models/current/dialogue -u models/current/nlu --endpoints endpoints.yml
	
action-server:
	python -m rasa_core_sdk.endpoint --actions actions

run:
	python -m rasa_core.run -d models/current/dialogue -u models/current/nlu --port 5002 --credentials credentials.yml

# core-server:
# 	python -m rasa_core.run --enable_api -d models/current/dialogue -u models/current/nlu -o out.log --endpoints endpoints.yml --port 5002 --credentials creds/credentials.yml

core-graph:
	python -m rasa_core.visualize -d domain.yml -s data/stories.md -o graph.html -c default_config.yml