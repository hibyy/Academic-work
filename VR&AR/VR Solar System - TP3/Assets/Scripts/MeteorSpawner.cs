using UnityEngine;

public class MeteorSpawner : MonoBehaviour
{
    public GameObject meteorPrefab;
    public float spawnInterval = 1.0f;
    public float spawnHeight = 10f;

    private float timer = 0f;

    void Update()
    {
        timer += Time.deltaTime;

        if (timer >= spawnInterval)
        {
            SpawnMeteor();
            timer = 0f;
        }
    }

    void SpawnMeteor()
    {
        float x = Random.Range(-10f, 10f);
        float z = Random.Range(-10f, 10f);

        Vector3 randomPos = new Vector3(x, spawnHeight, z);
        Quaternion randomRot = Random.rotation;

        Instantiate(meteorPrefab, randomPos, randomRot);
    }
}