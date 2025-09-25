import 'package:flutter/material.dart';

class CustomPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final void Function(int) onPageChanged;

  const CustomPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  Widget _pageButton(int page, bool isActive) {
    return InkWell(
      onTap: () => onPageChanged(page),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          page.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [];
    pages.add(
      InkWell(
        onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text("Prev",
              style: TextStyle(
                color: currentPage > 1 ? Colors.black87 : Colors.grey,
              )),
        ),
      ),
    );

    if (totalPages <= 5) {
      for (int i = 1; i <= totalPages; i++) {
        pages.add(_pageButton(i, i == currentPage));
      }
    } else {
      pages.add(_pageButton(1, currentPage == 1));
      if (currentPage > 2 && currentPage < totalPages - 1) {
        pages.add(_pageButton(currentPage, true));
        if (currentPage + 1 < totalPages) pages.add(_pageButton(currentPage + 1, false));
      } else if (currentPage >= totalPages - 1) {
        pages.add(_pageButton(totalPages - 1, currentPage == totalPages - 1));
      } else {
        pages.add(_pageButton(2, currentPage == 2));
      }
      pages.add(const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Text("...", style: TextStyle(fontWeight: FontWeight.bold)),
      ));
      pages.add(_pageButton(totalPages, currentPage == totalPages));
    }

    // Next button
    pages.add(
      InkWell(
        onTap: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text("Next",
              style: TextStyle(
                color: currentPage < totalPages ? Colors.black87 : Colors.grey,
              )),
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pages,
    );
  }
}
