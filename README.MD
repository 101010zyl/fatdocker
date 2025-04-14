# fatdocker

---
Docker with anything to use. Never reduce package and clean cache.

## Usage

```bash
git clone 
cd fatdocker
```
1. Build the image
```bash
docker build -t fatdocker:1.0 .
```
2. Run the image
```bash
export PORT1=1111
export PORT2=2222
export WORKSPACE=/path/to/your/workspace
docker run -p $PORT1:$PORT1 -p $PORT2:$PORT2 -v $WORKSPACE:/workspace --gpus all --name <project_name> -it fatdocker:1.0 /bin/bash
```

3. Run the container
```bash
docker exec -it <project_name> /bin/bash
```
