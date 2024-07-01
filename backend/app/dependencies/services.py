

# def get_ammo_service(
#         minio_client: Minio = Depends(get_minio_client),
#         request_repository: RequestRepository = Depends(get_repository(RequestRepository)),
#         header_repository: HeaderRepository = Depends(get_repository(HeaderRepository))
# ):
#     return AmmoService(minio_client, request_repository, header_repository)