import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/features/student/domain/entities/student.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.selectedBatch,
    required this.studentModel,
  });

  final String selectedBatch;
  final Student studentModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: studentModel.imageUrl.isEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/pp_placeholder.png',
                            fit: BoxFit.cover,
                            height: 88,
                            width: 80,
                          ),
                        )
                      : CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: 88,
                          width: 80,
                          imageUrl: studentModel.imageUrl,
                          placeholder: (context, url) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/pp_placeholder.png',
                              fit: BoxFit.cover,
                              height: 88,
                              width: 80,
                            ),
                          ),
                          errorWidget: (context, url, error) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/pp_placeholder.png',
                              fit: BoxFit.cover,
                              height: 88,
                              width: 80,
                            ),
                          ),
                        ),
                ),
                if (studentModel.isClaimed)
                  Icon(Icons.verified, color: Colors.green.shade700, size: 16),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studentModel.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Row(
                    spacing: 16,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6,
                        children: [
                          Container(
                            padding: const .symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.grey.shade200,
                            ),
                            child: Text(
                              studentModel.batch,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall!.copyWith(fontSize: 10),
                            ),
                          ),

                          Container(
                            padding: const .symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.grey.shade200,
                            ),
                            child: Text(
                              studentModel.session,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall!.copyWith(fontSize: 10),
                            ),
                          ),
                        ],
                      ),

                      Text(
                        '|',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                      //
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6,
                        children: [
                          Text(
                            'Blood:',
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                          ),
                          Text(
                            studentModel.bloodGroup,
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    spacing: 6,
                    children: [
                      Text(
                        'Student Id:',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        studentModel.studentId,
                        style: Theme.of(context).textTheme.bodySmall!
                            .copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),


                  if (studentModel.hall != 'None') ...[
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hall: ',
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                        ),
                        Expanded(
                          child: Text(
                            studentModel.hall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  fontSize: 12,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
